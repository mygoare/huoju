class SessionsController < ApplicationController
  skip_before_action  :require_login, only: [:new, :create]

  def new
    if logged_in?
      redirect_to '/'
    end
  end

  def create
    email = params[:user][:email]
    pwd   = params[:user][:pwd]
    @user = User.authenticate(email, pwd)
    if @user
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to :back
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:email, :pwd)
  end
end
