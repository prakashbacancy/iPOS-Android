class HomesController < ApplicationController
  
  def dashboard
    if user_signed_in? && (current_user.role.try(:name) == 'superadmin')
      redirect_to admin_users_path
    else
      redirect_to admin_users_path
    end  
  end
end
