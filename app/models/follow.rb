class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  after_create :add_follow_request
  after_destroy :remove_follow_request

  enum :status, { pending: 0, accepted: 1 }

  validates :follower_id, uniqueness: { scope: :following_id }

  scope :follower_instances, ->(user) { find_by("status = ?, following_id = ?", 1, user.id) }

  def add_follow_request
    broadcast_prepend_to(
      "follow_request_stream_#{self.following_id}",
      target: "follow_requests_#{self.following_id}",
      partial: "follows/follow_requests/name_links",
      locals: { follow: self }
    )
  end

  def remove_follow_request
    broadcast_remove_to(
      "follow_request_stream_#{self.following_id}",
      target: "follow_#{self.id}"
    )
  end
end
