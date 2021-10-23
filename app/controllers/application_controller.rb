class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    # finds user with session data and stores it if present
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_user_logged_in!
    # allows only logged in user
    redirect_to sign_in_path, alert: 'You must be signed in' if Current.user.nil?
  end

  def check_admin_level
    redirect_to sign_in_path, alert: 'Access denied' unless Current.user && Current.user.admin_level > 0
  end

  def total_pages
    count = Movie.all.count
    rem = (count % 5 == 0) ? 0 : 1
    t_pages = count / 5 + rem
    t_pages
  end
end
