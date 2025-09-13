FactoryBot.define do
  user_name = Faker::Internet.unique.username
  factory :user do
    username { user_name }
    email { Faker::Internet.email(name: user_name, domain: "mail.com") }
    password { 123456 }
  end
end
