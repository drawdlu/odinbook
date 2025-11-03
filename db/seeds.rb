# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Development and Test Seeds
if Rails.env.development? || Rails.env.test?
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
end

# Production showcase seeds
if Rails.env.production?
  # Create users
  password = "1234Aa*&"
  user1 = User.find_or_create_by!(email: "steve@mail.com") do |u|
    u.username = "steve"
    u.password = password
  end
  user2 = User.find_or_create_by!(email: "pedro@mail.com") do |u|
    u.username = "pedro"
    u.password = password
  end
  user3 = User.find_or_create_by!(email: "stan@mail.com") do |u|
    u.username = "stan"
    u.password = password
  end

  # Update Profile About
  user1.profile.update(about: "Cycling is a good hobby")
  user2.profile.update(about: "Programmer / Software Developer")
  user3.profile.update(about: "Lawyer in the making")

  # Create follow instances
  user1.followed_users.find_or_create_by!(following: user2, status: 1)
  user2.followed_users.find_or_create_by!(following: user3, status: 1)
  user3.followed_users.find_or_create_by!(following: user1, status: 1)
  user2.follower_users.find_or_create_by!(follower: user3, status: 1)
  user1.follower_users.find_or_create_by!(follower: user1, status: 1)

  # Create posts
  text1 = Text.find_or_create_by!(content: "This is a great day")
  text2 = Text.find_or_create_by!(content: "Getting better with time")
  text3 = Text.find_or_create_by!(content: "Passed the bar exams today")
  text4 = Text.find_or_create_by!(content: "Nowhere to hide")
  text5 = Text.find_or_create_by!(content: "Why are they this active everyday?")

  post1 = user1.posts.find_or_create_by!(postable: text1)
  post2 = user2.posts.find_or_create_by!(postable: text2)
  post3 = user3.posts.find_or_create_by!(postable: text3)
  post4 = user1.posts.find_or_create_by!(postable: text4)
  post5 = user2.posts.find_or_create_by!(postable: text5)

  # Comment on posts
  post1.comments.find_or_create_by!(user: user1, body: "Got my drivers licencse")
  post1.comments.find_or_create_by!(user: user2, body: "Could be better")
  post1.comments.find_or_create_by!(user: user3, body: "I know right")
  post2.comments.find_or_create_by!(user: user1, body: "Glad you're feeling better")
  post2.comments.find_or_create_by!(user: user3, body: "That's great")
  post3.comments.find_or_create_by!(user: user1, body: "Congratulations!")
  post3.comments.find_or_create_by!(user: user2, body: "Wow, who could have known")
  post4.comments.find_or_create_by!(user: user2, body: "But underground")
  post4.comments.find_or_create_by!(user: user3, body: "What are you talking about?")
  post5.comments.find_or_create_by!(user: user1, body: "Because they want to be")
  post5.comments.find_or_create_by!(user: user3, body: "who cares?")

  # Like posts
  post1.likes.find_or_create_by!(user: user2)
  post2.likes.find_or_create_by!(user: user1)
  post3.likes.find_or_create_by!(user: user2)
  post3.likes.find_or_create_by!(user: user1)
  post4.likes.find_or_create_by!(user: user3)
  post5.likes.find_or_create_by!(user: user1)
end
