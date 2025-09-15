FactoryBot.define do
  factory :comment do
    post { nil }
    user { nil }
    body { "MyString" }
  end
end
