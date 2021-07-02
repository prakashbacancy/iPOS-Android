class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :verify_auth_token, except: :logout
  before_action :set_current_version
  
  def create
    @user = User.find_by_email(params[:email].downcase)
    if @user && @user.valid_password?(params[:password])
      token = @user.genrate_device_token
      Apartment::Tenant.switch!(@user&.location&.subdomain)
      api_success(200, "Sign in successfully!", UserSerializer.new(@user, token: token))
    else
      api_error(400,'Invalid Email or Password')
    end
  end

  def reset_password
    @user = User.find_by_email(params[:email].downcase)
    if @user
      @user.send_reset_password_instructions
      api_success(200, 'You will receive an email with reset password instructions.')
    else
      api_error(400, 'No User found with this email.')
    end
  end

  def logout
    @user = User.find_by_email(params[:email].downcase)
    if @user
      # free terminal & delete token after logout
      terminals = Terminal.where(user_auth_token: request.headers['TOKEN'])
      Employee.where(current_terminal_id: terminals.ids).update_all(current_terminal_id: nil)
      terminals.update_all(device_token: nil, user_auth_token: nil, application_uniq_id: nil)
      DeviseToken.find_by(auth_token: request.headers['TOKEN']).destroy
      api_success(200, 'User logout successfully.')
    else
      api_error(400, 'No User found with this email.')      
    end
  end

  def logout_and_login
    @user = User.find_by_email(params[:email].downcase)
    if @user
      # free terminal & delete token after logout
      Terminal.where(user_auth_token: request.headers['TOKEN']).update_all(device_token: nil, user_auth_token: nil)
      DeviseToken.find_by(auth_token: request.headers['TOKEN']).destroy

      token = @user.genrate_device_token
      Apartment::Tenant.switch!(@user&.location&.subdomain)
      api_success(200, "Sign in successfully!", UserSerializer.new(@user, token: token))
    else
      api_error(400, 'No User found with this email.')      
    end
  end


  def terms_and_conditions
    @setting = Setting.find_by(title: 'iPos Privacy Policy')
    if @setting.present?
      api_success(200, "Terms and condition fetch successfully.", @setting.try(:description))
    else
      api_success(400, "Terms and condition page not found.")
    end
  end

  def configurator_status
    @user = User.find(params[:id])
    @user.update_columns(last_screen: params[:last_screen])
    data = {user_id: @user.id, last_screen: @user.last_screen }
    api_success(200, "Update Configurator status.", data)
  end

  def send_order_email_receipt
    @order = Order.find_by(id: params[:id])
    if @order
      # OrderMailerWorker.perform_async({email: params[:email], order_id: @order.id, receipt: true, subdomain: request.subdomain})
      OrderMailer.send_email_receipt(params[:email], @order).deliver_now
      api_success(200, "Email Receipt sent successfully")
    else
      api_success(400, "No order found.")
    end
  end

  def sms_order_detail
    @order = Order.find_by(id: params[:id])
    if @order
      link = @order.short_receipt_url
      sms_text = "Please review your Receipt at #{@order.location.business_name} #{link}"
      sms_status = SendSms.new(params[:phone_no], sms_text).call()
      if (sms_status != nil)
        api_success(200, "Text Receipt sent Successfully!")
      else
        api_success(400, "Not Sent.")
      end
    else
      api_success(400, "No order found.")
    end
  end

  def api_versions
    api_version = ApiVersion.first
    api_version.update(current_version: params[:current_version])
    api_success(200, "Api version successfully updated.", api_version)
  end

  def api_record_data
    data = ResponseRecord.new(response_data: params[:record])
    if data.save
      api_success(200, "Response save Successfully!")
    else
      api_success(400, "Response Not Save!")
    end
  end
end
