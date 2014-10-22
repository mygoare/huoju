class UserMailer < ActionMailer::Base
  default from: "伙聚 Huoju.co<no-reply@huoju.co>"

  def welcome_email(user)
    @user = user
    # raise request
    @url  = 'http://example.com/active_your_account'
    mail(to: @user.email, subject: '欢迎加入 伙聚 大家庭！')
  end
end
