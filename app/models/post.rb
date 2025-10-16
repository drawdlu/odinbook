class Post < ApplicationRecord
  include Streamable

  belongs_to :user
  belongs_to :postable, polymorphic: true

  after_create :broadcast_post
  after_destroy :remove_post
  after_validation :remove_postable_errors

  has_many :likes, dependent: :destroy
  has_many :user_likes, through: :likes, source: "user"

  has_many :comments, dependent: :destroy
  has_many :commenting_users, through: :comments, source: "user"

  validates :postable_id, presence: true

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

  def owned_by?(user)
    self.user == user
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

  def remove_post
    broadcast_remove_to(
      "post_index_stream",
      target: "post_#{self.id}"
    )
  end

  def remove_postable_errors
    errors.delete(:postable_id)
  end
end
