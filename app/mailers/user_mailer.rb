class UserMailer < ActionMailer::Base
  default from: "no-reply@huoju.co"

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/active_your_account'
    mail(to: @user.email, subject: '欢迎加入 伙聚 大家庭！')
  end
end
