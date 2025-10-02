class Post < ApplicationRecord
  include Streamable

  belongs_to :user

  after_create :broadcast_post

  has_many :likes, dependent: :destroy
  has_many :user_likes, through: :likes, source: "user"

  has_many :comments, dependent: :destroy
  has_many :commenting_users, through: :comments, source: "user"

  validates :body, presence: true

  def get_like_id(user)
    user.likes.where(post_id: self.id).first.id
  end

  def liked_by?(user)
    user.liked_posts.map(&:id).include?(self.id)
  end

  def own_post(user)
    user.present? && self.user_id == user.id
  end

  def allowed_users
    self.user.followers
  end

  def broadcast_post
    get_user_stream(self).each do |user|
      PostsChannel.broadcast_to(
        user,
        { html: ApplicationController.render(
          partial: "posts/post_template",
          locals: { post: self }
        ) }
      )
    end
  end
end
