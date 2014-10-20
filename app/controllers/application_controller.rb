class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def logged_in?
    current_user != nil
  end

  before_action :require_login

  after_filter :store_location

  private

  def require_login
    unless logged_in?
      # todo: add with redirect_to=user/mygoare
      # raise "#{request.path}, #{request.fullpath()}, #{request.get?()}"
      cookies[:redir_to] = request.fullpath()
      redirect_to user_signin_path
    end
  end

  def store_location
    return unless request.get?

    if (request.path != "/user/signup" &&
        request.path != "/user/signin" &&
        request.path != "/user/password/new")
      # raise request.path
      cookies[:redir_to] = request.fullpath()
    end
  end
end
