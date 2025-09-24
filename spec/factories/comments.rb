FactoryBot.define do
  factory :comment do
    post
    user
    body { "MyString" }
  end
end
