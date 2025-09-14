require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    context "when a user is signed in" do
      before { sign_in user }

      it "loads root path" do
        get root_path
        expect(response).to be_successful
      end
    end

    context "when a user is not signed in" do
      it "will redirect to login page" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
