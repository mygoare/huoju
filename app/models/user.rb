class User < ActiveRecord::Base
  has_many :events, dependent: :destroy

  validates :user_name, :email, presence: true
  validates :user_name, :email, uniqueness: true

  attr_accessor :pwd
  before_save :encrypt_password
  def encrypt_password
    self.pwd_salt = BCrypt::Engine.generate_salt
    # raise "#{pwd}, #{pwd_salt}, #{self.inspect}"
    self.pwd_hash = BCrypt::Engine.hash_secret(pwd, pwd_salt)
  end

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
