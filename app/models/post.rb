class Post < ApplicationRecord
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
    self.user_id == user.id
  end

  def broadcast_post
    broadcast_prepend_to(
      "post",
      target: "posts",
      partial: "posts/post_template",
      locals: { post: self }
    )
  end
end
