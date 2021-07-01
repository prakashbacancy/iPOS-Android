class PasswordsController < Devise::PasswordsController
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?
    if resource.errors.empty?
      resource.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      sign_in(resource_name, resource)
      redirect_to root_path, notice: "Password updated successfully."
    else
      render :edit
    end
  end
end
