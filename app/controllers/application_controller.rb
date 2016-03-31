class ApplicationController < ActionController::Base
  helper_method :current_user, :owned_cat?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login!(user)
    @current_user = user
    @current_session = Session.create!(user_id: @user.id, browser: browser)
    session[:session_token] = current_session.session_token
  end

  def login_user!(user)
    login!(@user)
    redirect_to cats_url
  end

  def current_user
    @current_user ||= current_session ? current_session.user : nil
  end

  def current_session
    @current_session ||= Session.find_by_session_token(session[:session_token])
  end

  def redirect_if_logged_in
    redirect_to cats_url if current_user
  end

  def owned_cat?(cat_id)
    !current_user.cats.find_by_id(cat_id).nil?
  end

  def require_login
    redirect_to new_session_url unless current_user
  end

  def browser
    result = request.env["HTTP_USER_AGENT"]

    %w(Chrome Safari Firefox Opera).each do |browser|
      return browser if result.include?(browser)
    end
  end
end
