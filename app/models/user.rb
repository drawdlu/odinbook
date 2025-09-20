class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

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

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { in: 4..32  },
            format: { without: /\s/, message: "should not contain any whitespace" }
  validates :email, presence: true, uniqueness: true

  scope :all_except, ->(user) { where.not(id: user) }

  def follower?(current_user)
    self.followers.to_a.include?(current_user)
  end

  def pending_follower?(current_user)
    self.pending_followers.to_a.include?(current_user)
  end

  def follower_id(current_user)
    self.follower_users.find_by(follower_id: current_user.id).id
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
          username: data["name"],
          email: data["email"],
          password: Devise.friendly_token[0, 20]
        )
    end

    user
  end
end
