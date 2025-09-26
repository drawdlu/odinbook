require 'rails_helper'

RSpec.describe "Follows::Followers", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /index" do
    it "loads page successfully" do
      get user_followers_path(user_id: user.id)

      expect(response).to be_successful
    end
  end
end
