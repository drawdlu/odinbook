require 'rails_helper'

RSpec.describe "Sign In", type: :system do
  let(:email) { "test@mail.com" }
  let!(:user) { create(:user, email: email) }

  context "when signing in using username and password" do
    before do
      visit root_path
    end

    it "signs in when using valid credentials" do
      fill_in("Username", with: user.username)
      fill_in("Password", with: user.password)
      click_button "Log in"

      expect(page).to have_current_path(root_path)
    end

    it "fails to sign in when password is wrong" do
      fill_in("Username", with: user.username)
      fill_in("Password", with: "wrong_password")
      click_button "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text("Invalid Username or password.")
    end
  end
  context "when signing up using google oauth" do
    let!(:user) { create(:user, email: "test@mail.com") }

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
