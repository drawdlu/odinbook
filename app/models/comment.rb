class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create :broadcast_comment

  validates :body, presence: true

  def own_comment(user)
    self.user_id == user.id
  end

  def broadcast_comment
    broadcast_prepend_to(
      "comment",
      target: "comments_#{self.post.id}",
      partial: "comments/comment",
      locals: { post: self.post, comment: self }
    )
  end
end
