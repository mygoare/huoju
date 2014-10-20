class User < ActiveRecord::Base
  has_many :events, dependent: :destroy

  validates :user_name, :email, presence: true
  validates :user_name, :email, uniqueness: true

  def self.authenticate(email, pwd)
    user = User.find_by(email: email)
    # raise BCrypt::Engine.hash_secret(pwd, user.pwd_salt)
    if user && user.pwd_hash == BCrypt::Engine.hash_secret(pwd, user.pwd_salt)
      user
    else
      nil
    end
  end
end
