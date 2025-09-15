class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :user_likes, through: :likes, source: "user"

  has_many :comments, dependent: :destroy
  has_many :commenting_users, through: :comments, source: "user"

  validates :body, presence: true
end
