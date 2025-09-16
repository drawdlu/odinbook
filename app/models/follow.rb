class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  enum :status, { pending: 0, accepted: 0 }

  validates :follower_id, uniqueness: { scope: :following_id }
end
