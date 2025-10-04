class Picture < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy

  has_one_attached :content, dependent: :destroy
end
