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
    if (email.empty? or pwd.empty?)
      flash[:error] = "邮箱或密码不得为空"
      redirect_to :back and return
    end
    @user = User.authenticate(email, pwd)
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "#{@user.user_name}, 欢迎回来"
      redirect_to '/'
    else
      flash[:error] = "邮箱或密码错误!"
      redirect_to :back
    end
  end

  def destroy
    session[:user_id] = nil

    flash[:notice] = "已注销"
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:email, :pwd)
  end
end
