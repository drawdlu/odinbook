require 'rails_helper'

RSpec.describe "Follows::Followings", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /index" do
    it "loads page succesfully" do
      get user_followings_path(user)

      expect(response).to be_successful
    end
  end
end
