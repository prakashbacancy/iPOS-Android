class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :current_location

	def current_location
    @current_location ||= if user_signed_in?
      current_user.location || Location.find_by(subdomain: request.subdomain)
    else
      Location.find_by(subdomain: request.subdomain)
    end
  end

  # Redirects to a path after sign in.
  def after_sign_in_path_for(resource)
    if user_signed_in?
      root_url(subdomain: resource&.location&.subdomain.to_s)
    elsif current_user.role.try(:name) == 'super_admin'
      signin_with_otp_already? ? admin_users_path : admin_send_otp_path
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_url(subdomain: nil)
  end
end
