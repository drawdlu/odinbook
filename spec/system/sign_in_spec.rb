require 'rails_helper'

RSpec.describe "Sign In", type: :system do
  context "when signing up using google oauth" do
    let!(:user) { create(:user, email: "test@mail.com") }

    before do
      mock_oauth_provider(:google_oauth2)
    end

    after do
      OmniAuth.config.test_mode = false
      OmniAuth.config.mock_auth[:google_oauth2] = nil
    end

    it "signs in the user" do
      visit root_path

      click_button "Sign in with Google"

      expect(page).to have_current_path(root_path)
    end
  end
end
