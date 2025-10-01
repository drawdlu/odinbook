class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create :broadcast_comment
  after_destroy :broadcast_remove_comment

  validates :body, presence: true

  def own_comment(user)
    user.present? && self.user_id == user.id
  end

  def broadcast_comment
    self.post.allowed_user.each do
      broadcast_prepend_to(
        "comments_stream_#{self.post.id}",
        target: "comments_#{self.post.id}",
        partial: "comments/comment",
        locals: { post: self.post, comment: self, current_user: user }
      )
    end
  end

  def broadcast_remove_comment
    broadcast_remove_to(
      "comments_stream_#{self.post.id}",
      target: "comment_#{self.id}"
    )
  end
end
