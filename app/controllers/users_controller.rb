class UsersController < ApplicationController
  skip_before_action  :require_login, only: [:new, :create, :show, :reset_pwd]

  def new
    if logged_in?
      redirect_to '/'
    end
  end

  def create
    user_params = params[:user]
    pwd_salt = BCrypt::Engine.generate_salt
    pwd_hash = BCrypt::Engine.hash_secret(user_params[:pwd], pwd_salt)

    @user = User.new
    @user.user_name = user_params[:user_name]
    @user.email = user_params[:email]
    @user.pwd_salt = pwd_salt
    @user.pwd_hash = pwd_hash

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

  def change_pwd user
    pwd_hash        = user.pwd_hash
    pwd_salt        = user.pwd_salt

    current_pwd     = params[:current_pwd]

    new_pwd         = params[:new_pwd]
    confirm_new_pwd = params[:confirm_new_pwd]

    if current_pwd.empty? or new_pwd.empty? or confirm_new_pwd.empty?
      flash[:error] = "不得为空,所有都是必填项"
      redirect_to :back and return
    end

    if new_pwd != confirm_new_pwd
      flash[:error] = "两次秘密输入不一样"
      redirect_to :back and return
    end

    if pwd_hash != BCrypt::Engine.hash_secret(current_pwd, pwd_salt)
      flash[:error] = "原密码输入不正确"
      redirect_to :back and return
    end

    if user.update(pwd_hash: BCrypt::Engine.hash_secret(new_pwd, pwd_salt))
      flash[:notice] = "修改密码成功"
      redirect_to :back
    else
      flash[:error] = "修改密码失败"
      redirect_to :back

    end
  end

  def update_profile user
    user_name = params[:user_name]
    profile = params[:profile]
    sex = params[:sex]

    if user.update(user_name: user_name, profile: profile, sex: sex)
      flash[:notice] = "更新资料成功"
      redirect_to :back
    else
      flash[:error] = "更新资料失败"
      redirect_to :back
    end
  end

  # /user/profile/edit
  def profile
    user_id         = session[:user_id]
    user            = User.find(user_id)

    if request.method == 'GET'
      @user_name = user.user_name
      @profile = user.profile
      @sex = user.sex
    end


    if request.method == 'POST'
      if params[:by] and params[:by] == 'pwd'
        change_pwd user
      else
        update_profile user
      end
    end
  end

end
