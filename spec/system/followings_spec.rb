require 'rails_helper'

RSpec.describe "Followings", type: :system do
  let(:user) { create(:user) }
  let!(:follow) { create(:follow, follower: user, status: 1) }

  before do
    driven_by(:rack_test)
    login_as(user)
    click_link "Profile"
    click_link "Following"
  end

  it "displays followed user" do
    expect(page).to have_content(follow.following.username)
    expect(page).to have_selector(:link_or_button, "Unfollow")
  end
end
