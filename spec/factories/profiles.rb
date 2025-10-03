FactoryBot.define do
  factory :profile do
    image { "MyText" }
    about { "MyText" }
    first_name { "MyText" }
    last_name { "MyText" }
    user
  end
end
