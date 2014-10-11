class SessionsController < ApplicationController
  def new
  end

  def create

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
