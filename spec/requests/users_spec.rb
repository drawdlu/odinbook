require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    context "when logged in" do
      let(:user) { create(:user) }
      before { sign_in user }
      it "loads successfully" do
        get users_path
        expect(response).to be_successful
      end
    end

    context "when not logged in" do
      it "redirects to log in page" do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
