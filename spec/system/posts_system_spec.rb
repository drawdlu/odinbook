require 'rails_helper'

RSpec.describe "Posts index page", type: :system do
  let(:user) { create(:user) }
  before do
    driven_by(:rack_test)
    sign_in user
  end

  it "renders posts by user" do
    post = create(:post, user: user)

    visit root_path
    expect(page).to have_text(post.body)
    expect(page).to have_text(post.user.username)
  end

  it "renders posts by user followings" do
    followed= create(:user)
    post = create(:post, user: followed)
    user.followings<<(followed)

    visit root_path
    expect(page).to have_text(post.body)
    expect(page).to have_text(post.user.username)
  end

  it "does not render posts from user followers" do
    follower = create(:user)
    post = create(:post, user: follower)
    user.followers<<(follower)

    visit root_path
    expect(page).to_not have_text(post.body)
    expect(page).to_not have_text(post.user.username)
  end
end
