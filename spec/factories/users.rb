FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 4..32) }
    email { Faker::Internet.email(name: username, domain: "mail.com") }
    password { "1234Aa*&" }
  end
end
