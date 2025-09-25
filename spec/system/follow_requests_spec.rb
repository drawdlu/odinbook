require 'rails_helper'

RSpec.describe "FollowRequests", type: :system do
  let(:user) { create(:user) }
  let!(:follow) { create(:follow, following: user) }

  before do
    driven_by(:rack_test)
    login_as(user)
    click_link "Follow Requests"
  end

  describe "accepting a request" do
    it "removes link and prints accepted" do
      click_link "Accept"

      expect(page).to have_content("(Accepted)")
    end
  end

  describe "denying a request" do
    it "removes link and prints denied" do
      click_link "Deny"

      expect(page).to have_content("(Denied)")
    end
  end
end
