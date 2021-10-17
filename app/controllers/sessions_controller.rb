class SessionsController < ApplicationController
  def new
    render template: 'authorizations/authorization', locals: { form_type: :login }  
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render template: 'authorizations/authorization', locals: { form_type: :login }, status: 422
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out'
  end
end