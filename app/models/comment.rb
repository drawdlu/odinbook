class Comment < ApplicationRecord
  include Streamable

  belongs_to :post
  belongs_to :user

  after_create_commit :broadcast_comment
  after_destroy :broadcast_remove_comment

  validates :body, presence: true

  def own_comment(user)
    user.present? && self.user_id == user.id
  end

  def can_delete?(user)
    puts "test test test"
    self.own_comment(user) || self.post.own_post(user)
  end

  def broadcast_comment
    broadcast_prepend_later_to(
      "comments_stream_#{self.post.id}",
      target: "comments_#{self.post.id}",
      partial: "comments/comment",
      locals: { post: self.post, comment: self }
    )
  end

  def broadcast_remove_comment
    broadcast_remove_to(
      "comments_stream_#{self.post.id}",
      target: "comment_#{self.id}"
    )
  end
end
