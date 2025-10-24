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

include FactoryBot::Syntax::Methods

# Users
# all users will have a password of 1234Aa*&
users = []
10.times do
  users.push(create(:user))
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
  posts.push(create(:post, user: users.sample))
end

# Comments
10.times do
  create(:comment, user: users.sample, post: posts.sample)
end

# Likes
10.times do
  Like.find_or_create_by(post: posts.sample, user: users.sample)
end
