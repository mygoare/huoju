class UsersController < ApplicationController
  def new
  end

  def create
    # raise params.inspect
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :pwd)
  end

end
