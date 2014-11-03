class UsersController < ApplicationController
  skip_before_action  :require_login, only: [:new, :create, :show, :reset_password_new, :reset_password_change]

  def new
    if logged_in?
      redirect_to '/'
    end
  end

  def create
    user_params = params[:user]

    if (!user_params[:user_name].nil? or !user_params[:email].nil? or !user_params[:pwd].nil?)
      flash[:error] = "邮箱，用户名或密码不得为空"
      redirect_to :back and return
    end

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

      redir_to_path = cookies[:redir_to]
      if redir_to_path
        redirect_to redir_to_path
      else
        redirect_to '/'
      end
    else
      redirect_to :back
    end
  end

  def show
    @user = User.find_by!(user_name: params[:user_name])
  end

  def reset_password_new
    if request.post?
      email = params[:user][:email]
      @user = User.find_by(email: email)

      if @user
        if @user.email_valid
          # generate reset_password_token & send email
          reset_password_change = SecureRandom.urlsafe_base64(48)
          @user.update!(reset_password_token: reset_password_change)
          UserMailer.reset_password(@user).deliver

          # email_confirmation_token

          redirect_to '/'
          flash[:notice] = "重置密码邮件发送成功"
        else
          flash[:error] = "请先验证邮箱"
        end
      else
        flash[:error] = "该邮箱不存在"
      end
    end
  end

  def reset_password_change
    if request.get?
      @reset_password_token = params[:reset_password_token]
    end

    if request.post?
      reset_password_token = params[:reset_password_token]
      new_password = params[:new_password]
      confirm_new_password = params[:confirm_new_password]

      @user = User.find_by(reset_password_token: reset_password_token)
      if reset_password_token and @user and new_password == confirm_new_password
        @user.update!(pwd_hash: BCrypt::Engine.hash_secret(new_password, @user.pwd_salt), reset_password_token: '')

        session[:user_id] = @user.id
        flash[:notice] = "#{@user.user_name}, 找回密码成功，欢迎回来"
        redirect_to '/'
      else
        redirect_to :back
        flash[:error] = "Reset Password Token 无效"
      end
    end
  end

  def change_password user
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

    if request.get?
      @user_name = user.user_name
      @profile = user.profile
      @sex = user.sex
    end


    if request.post?
      if params[:by] and params[:by] == 'pwd'
        change_password user
      else
        update_profile user
      end
    end
  end

  def confirm_email_send
    @user = User.find(session[:user_id])

    if @user
      email_confirmation_token = SecureRandom.urlsafe_base64(48)
      @user.update!(email_confirmation_token: email_confirmation_token)
      UserMailer.confirm_email(@user).deliver

      flash[:notice] = "已发送验证邮件到您的邮箱"

      redirect_to '/'
    else
      flash[:error] = "用户不存在"
      session[:user_id] = nil

      redirect_to '/'
    end
  end

  def confirm_email
    email_confirmation_token = params[:email_confirmation_token]
    @user = User.find_by(email_confirmation_token: email_confirmation_token)

    if @user
      @user.update!(email_valid: true, email_confirmation_token: '')

      flash[:notice] = "邮箱已验证"
    else
      flash[:error] = "Email Confirmation Token 无效"
    end
    redirect_to '/'
  end

end
