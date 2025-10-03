require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:profile) { create(:profile) }

  before { sign_in profile.user }
  describe "GET /show" do
    it "successfully loads profile" do
      get user_profile_path(user_id: profile.user.id)

      expect(response).to be_successful
    end
  end
end
