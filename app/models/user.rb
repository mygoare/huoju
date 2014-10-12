class User < ActiveRecord::Base
  has_many :events, dependent: :destroy

  validates :user_name, :email, :pwd, presence: true
  validates :user_name, :email, uniqueness: true

end
