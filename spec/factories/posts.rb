FactoryBot.define do
  factory :post do
    user
    postable { create(:text) }
  end
end
