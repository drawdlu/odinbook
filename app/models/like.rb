class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, uniqueness: { scope: :user_id }

  after_create :broadcast_like
  after_destroy :broadcast_like

  def broadcast_like
    broadcast_update_to(
      "like",
      partial: "likes/like_count",
      target: "like_count_#{post.id}",
      locals: { post: self.post }
    )
  end
end
