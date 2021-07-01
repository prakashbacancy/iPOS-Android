class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    if resource.role.try(:name) == 'employee'
      if resource.is_employee_confirmed
        sign_in(resource_name, resource)
        if !session[:return_to].blank?
          redirect_to session[:return_to]
          session[:return_to] = nil
        else
          respond_with resource, location: after_sign_in_path_for(resource)
        end
      else
        sign_out(resource)
        redirect_to root_url(subdomain: nil)
      end
    else
      sign_in(resource_name, resource)
      if !session[:return_to].blank?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
  end
end