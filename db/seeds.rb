# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'factory_bot_rails'
require 'faker'

include FactoryBot::Syntax::Methods

# Users
# all users will have a password of 1234Aa*&
users = []
10.times do
  users.push(create(:user))
end

# Profile
users.each do |user|
  sentence = Faker::Lorem.sentence(word_count: rand(3..6))
  user.profile.update(about: sentence)
end

# Follows
15.times do
  following = users.sample
  follower = (users - [ following ]).sample

  Follow.find_or_create_by(following: following, follower: follower, status: 1)
end

# Posts
posts = []
10.times do
  content = Faker::Lorem.sentence(word_count: rand(2..5))
  text = Text.create(content: content)
  posts.push(create(:post, user: users.sample, postable: text))
end

# Comments
10.times do
  sentence = Faker::Lorem.sentence(word_count: rand(1..3))
  create(:comment, user: users.sample, post: posts.sample, body: sentence)
end

# Likes
10.times do
  Like.find_or_create_by(post: posts.sample, user: users.sample)
end
