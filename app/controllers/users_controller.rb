class UsersController < ApplicationController
  skip_before_action  :require_login, only: [:new, :create, :show]

  def new
    if logged_in?
      redirect_to '/'
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # raise @user.inspect
      session[:user_id] = @user.id
      # UserMailer.welcome_email(@user).deliver

      redirect_to '/'
    else
      redirect_to :back
    end
  end

  def show
    @user = User.find_by!(user_name: params[:user_name])
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :pwd)
  end

end
