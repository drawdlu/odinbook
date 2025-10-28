require 'rails_helper'

RSpec.describe "Followers", type: :system do
  let(:user) { create(:user) }
  let(:follower_user) { create(:user) }
  let!(:follow) { create(:follow, follower: follower_user, following: user, status: 1) }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user)
    click_link "Profile"
    click_link "Followers"
  end

  context "following back" do
    it "updates linke to cancel request" do
      click_link "Follow back"

      expect(page).to have_selector(:link_or_button, "Cancel Request")
    end
  end

  context "cancelling follow request" do
    it "updates link to follow back" do
      click_link "Follow back"
      expect(page).to have_selector(:link_or_button, "Cancel Request")
      click_link "Cancel Request"
      expect(page).to have_selector(:link_or_button, "Follow back")
    end
  end

  context "unfollowing a user" do
    before do
      user.followed_users.create(following_id: follower_user.id, status: 1)
      click_link "Followers"
    end

    it "unfollows user and updates link to follow back" do
      expect(page).to have_selector(:link_or_button, "Unfollow")
      click_link "Unfollow"
      expect(page).to have_selector(:link_or_button, "Follow back")
    end
  end
end
