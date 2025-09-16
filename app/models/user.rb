class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  # Users that this user is following
  has_many :followed_users, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :pending_followings, -> { where("status = ?", 0) }, through: :followed_users, source: "following"
  has_many :followings, -> { where("status = ?", 1) }, through: :followed_users, source: "following"

  # Users that follow this user
  has_many :follower_users, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :pending_followers, -> { where("status = ?", 0) }, through: :follower_users, source: "follower"
  has_many :followers, -> { where("status = ?", 1) }, through: :follower_users, source: "follower"

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: "post"

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: "post"

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
