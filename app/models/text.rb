class Text < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy

  validates :content, presence: true
end
