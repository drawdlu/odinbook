class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  # Users that this user is following
  has_many :followed_users, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :followed_users, source: "following"

  # Users that follow this user
  has_many :following_users, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :following_users, source: "follower"

  validates :username, presence: true, uniqueness: true
end
