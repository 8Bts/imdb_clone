class RegistrationsController < ApplicationController
  def new
    @user = User.new
    render template: 'authorizations/authorization', locals: { form_type: :register }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Successfully created account'
    else
      render template: 'authorizations/authorization', locals: { form_type: :register }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
