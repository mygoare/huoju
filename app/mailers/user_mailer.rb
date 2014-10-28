class UserMailer < ActionMailer::Base
  default from: "伙聚 Huoju.co<no-reply@huoju.co>"

  def welcome_email(user)
    @user = user
    #todo: raise request
    @url  = 'http://example.com/active_your_account'
    mail(to: @user.email, subject: '欢迎加入 伙聚 大家庭！')
  end

  def reset_password user
    @user = user
    mail(to: @user.email, subject: '重置密码')
  end

  def confirm_email user
    @user = user
    mail(to: @user.email, subject: '验证邮箱')
  end
end
