FactoryBot.define do
  factory :post do
    user
    body { Faker::Lorem.paragraph(sentence_count: rand(1..3)) }
  end
end
