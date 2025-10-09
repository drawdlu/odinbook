require 'rails_helper'

RSpec.describe "Posts index page", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:user_post) { create(:post, user: user) }

  before do
    driven_by(:rack_test)
    login_as(user)
  end

  it "renders posts by user" do
    user_post

    visit root_path
    expect(page).to have_content(user_post.postable.content)
    expect(page).to have_content(user_post.user.username)
  end

  it "renders posts by user followings (accepted)" do
    post = create(:post, user: another_user)
    user.followed_users.create(following_id: another_user.id, status: 1)

    visit root_path
    expect(page).to have_content(post.postable.content)
    expect(page).to have_content(post.user.username)
  end

  it "does not render posts from user followers" do
    post = create(:post, user: another_user)
    user.followers<<(another_user)

    visit root_path
    expect(page).to_not have_content(post.postable.content)
    expect(page).to_not have_content(post.user.username)
  end

  it "renders comments on post" do
    comment = create(:comment, user: another_user, post: user_post)

    visit root_path
    expect(page).to have_content(comment.body)
  end

  it "renders like number when it is greater than 0" do
    user_post.likes.create(user: another_user)

    visit root_path
    expect(page).to have_content(user_post.likes.count)
  end

  it "does not render like count when it is less than 1" do
    visit root_path
    expect(page).to_not have_content(user_post.likes.count)
  end
end
