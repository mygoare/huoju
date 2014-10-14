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
      UserMailer.welcome_email(@user).deliver

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

  def change_pwd
    user_id         = params[:user_id]
    user            = User.find(user_id)

    pwd_hash        = user.pwd_hash
    pwd_salt        = user.pwd_salt

    current_pwd     = params[:current_pwd]

    new_pwd         = params[:new_pwd]
    confirm_new_pwd = params[:confirm_new_pwd]

    if (current_pwd.empty? or new_pwd.empty? or confirm_new_pwd.empty?)
      flash[:error] = "不得为空,所有都是必填项"
      redirect_to :back

    elsif (new_pwd != confirm_new_pwd)
      flash[:error] = "两次秘密输入不一样"
      redirect_to :back


    elsif ( pwd_hash != BCrypt::Engine.hash_secret(current_pwd, pwd_salt) )
      flash[:error] = "原密码输入不正确"
      redirect_to :back


    elsif user.update(pwd: new_pwd)
      flash[:notice] = "更改密码成功"
      redirect_to :back
    else
      flash[:error] = "更改密码失败"
      redirect_to :back

    end




  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :pwd)
  end

end
