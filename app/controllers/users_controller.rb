class UsersController < ApplicationController
  skip_before_action  :require_login, only: [:new, :create, :show, :reset_pwd]

  def new
    if logged_in?
      redirect_to '/'
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id

      # validate email address
      # UserMailer.welcome_email(@user).deliver

      redirect_to '/'
    else
      redirect_to :back
    end
  end

  def show
    @user = User.find_by!(user_name: params[:user_name])
  end

  def reset_pwd

  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :pwd)
  end

end
