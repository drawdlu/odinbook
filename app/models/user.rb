class User < ApplicationRecord
  @@minimum_length = 4.freeze
  @@maximum_length = 32.freeze
  @@minimum_password_length = 8.freeze
  cattr_reader :maximum_length, :minimum_length, :minimum_password_length

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :posts, dependent: :destroy

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

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false },
            length: { in: @@minimum_length..@@maximum_length  },
            format: { without: /\s/, message: "should not contain any whitespace" },
            if: -> { username.present? }

  validates :email, presence: true, uniqueness: true
  validate :password_complexity, if: :password_required?


  scope :all_except, ->(user) { where.not(id: user) }

  def follower?(current_user)
    self.followers.exists?(current_user.id)
  end

  def pending_follower?(current_user)
    self.pending_followers.exists?(current_user.id)
  end

  def follower_id(follower)
    self.follower_users.find_by(follower_id: follower.id).id
  end

  def follow_requests
    follower_users.where("status = ?", 0)
  end

  def follower_instances
    follower_users.where("status = ?", 1)
  end

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.new(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid
      )

      user.save(validate: false)
    end

    user
  end

  def password_required?
    # No password required for OAuth users
    return false if provider.present?

    # Require password only when:
    # - New record (sign up)
    # - Or password fields are being changed
    !persisted? || password.present? || password_confirmation.present?
  end

  def password_complexity
    return if password.blank?

    errors.add :password, "must include an uppercase letter" unless password.match?(/[A-Z]/)
    errors.add :password, "must include a lowercase letter" unless password.match?(/[a-z]/)
    errors.add :password, "must include a symbol" unless password.match?(/[_\W]/)
    error.add :password, "must include a digit" unless password.match?(/[\d]/)
  end
end
