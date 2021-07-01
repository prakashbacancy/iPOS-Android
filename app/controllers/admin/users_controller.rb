class Admin::UsersController < ApplicationController

	def create
    @user = User.new(user_params)
    if @user.save
    	redirect_to edit_admin_user_path(@user, tab: 'location'), notice: 'Merchant was successfully created.'
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

  private
  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :role_id, :profile_pic)
  end
end
