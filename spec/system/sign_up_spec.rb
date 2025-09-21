require 'rails_helper'

RSpec.describe "Sign Up", type: :system do
  let(:user) { build(:user) }

  before do
    visit root_path
    click_link "Sign up"
  end

  context "when all data is valid" do
    it "successfully creates an account and logs in" do
      fill_in("Username", with: user.username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: user.password)
      click_button "Sign up"

      expect(page).to have_content("Welcome! You have signed up successfully.")
      expect(page).to have_current_path(root_path)
    end
  end

  context "when password is too short" do
    it "fails and prompts password too short" do
      fill_in("Username", with: user.username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: "1234")
      fill_in("Password confirmation", with: "1234")
      click_button "Sign up"
      sleep 1

      expect(page).to have_content("Password is too short (minimum is 6 characters)")
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context "when username or email has a duplicate" do
    let(:email) { "test@mail.com" }
    let(:username) { "test_name" }

    before do
      user.save
    end

    it "fails and prompts duplicate username" do
      fill_in("Username", with: user.username)
      fill_in("Email", with: email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: user.password)
      click_button "Sign up"

      expect(page).to have_content("Username has already been taken")
      expect(page).to have_current_path(new_user_registration_path)
    end

    it "fails and prompts duplicate email" do
      fill_in("Username", with: username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: user.password)
      click_button "Sign up"

      expect(page).to have_content("Email has already been taken")
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context "when password does not match" do
    it "fails and prompts password not match" do
      fill_in("Username", with: user.username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: "will_not_match")
      click_button "Sign up"

      expect(page).to have_content("Password confirmation doesn't match Password")
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context "when username length is invalid" do
    it "fails and displays error message" do
      invalid_username = "tes"
      fill_in("Username", with: invalid_username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: user.password)
      click_button "Sign up"

      expect(page).to have_content("Username is too short (minimum is 4 characters)")
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context "when username has a whitespace" do
    it "fails and displays error message" do
      invalid_username = "test test"
      fill_in("Username", with: invalid_username)
      fill_in("Email", with: user.email)
      fill_in("Password", with: user.password)
      fill_in("Password confirmation", with: user.password)
      click_button "Sign up"

      expect(page).to have_content("Username should not contain any whitespace")
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context "when signing up using google auth" do
    let(:name) { "Bombadil" }
    let(:user) { build(:user, email: "test@mail.com", username: "test") }
    let!(:active_user) { create(:user, username: name) }

    before do
      mock_oauth_provider(:google_oauth2)
      visit root_path
      click_button "Sign in with Google"
    end

    after do
      OmniAuth.config.test_mode = false
      OmniAuth.config.mock_auth[:google_oauth2] = nil
    end

    it "signs up successfully with valid username" do
      fill_in("Username", with: user.username)
      click_button "Sign up"

      expect(page).to have_current_path(root_path)
    end

    it "fails and renders notice when username is invalid" do
      fill_in("Username", with: name)
      click_button "Sign up"

      expect(page).to have_content("Username has already been taken")
    end
  end
end
