class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  after_create :add_follow_request
  after_destroy :remove_follow
  after_update :add_follower_following

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

  def remove_follow
    if self.status == "accepted"
      remove_from_followers
      remove_from_following
      update_user_link_on_unfollow
    else
      remove_from_requests
      update_user_link
      update_follower_page
    end
  end

  def add_follower_following
    add_follower
    add_following
    update_user_link
    update_follower_page
  end

  private

  def add_follower
    broadcast_prepend_to(
      "followers_#{self.following_id}",
      target: "follower-list",
      partial: "follows/follower_template",
      locals: { follow: self }
    )
  end

  def add_following
    broadcast_prepend_to(
      "following_#{self.follower_id}",
      target: "following-list",
      partial: "follows/following_template",
      locals: { follow: self }
    )
  end

  def update_user_link
    broadcast_update_to(
      "user_index_#{self.follower_id}",
      target: "user_link_#{self.following_id}",
      partial: "follows/link",
      locals: { user_id: self.following.id, follow_id: self.id }
    )
  end

  def update_follower_page
    broadcast_update_to(
      "followers_#{self.follower_id}",
      target: "user_link_#{self.following_id}",
      partial: "follows/link",
      locals: { user_id: self.following.id, follow_id: self.id }
    )
  end

  def remove_from_requests
    broadcast_remove_to(
      "follow_request_stream_#{self.following_id}",
      target: "follow_#{self.id}"
    )
  end

  def remove_from_followers
    broadcast_remove_to(
      "followers_#{self.following_id}",
      target: "follow_#{self.id}"
    )
  end

  def remove_from_following
    broadcast_remove_to(
      "following_#{self.follower_id}",
      target: "follow_#{self.id}"
    )
  end

  def update_user_link_on_unfollow
    # updates Follow or Follow Back only, not when link is Unfollow
    return if self.follower.follower?(self.following)

    broadcast_update_to(
      "user_index_#{self.following_id}",
      target: "user_link_#{self.follower_id}",
      partial: "follows/link",
      locals: { user_id: self.following.id, follow_id: self.id }
    )
  end
end
