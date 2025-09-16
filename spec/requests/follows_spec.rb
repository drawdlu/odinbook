require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }
  let(:follow_user) { create(:user) }

  describe "POST" do
    context "when a user is logged in" do
      before { sign_in user }

      it "creates a new instance of follow that is pending" do
        post follows_path(following_id: follow_user.id)
        follow = Follow.find_by(following_id: follow_user.id, follower_id: user.id)
        expect(follow).to_not be_nil
        expect(follow.status).to eq "pending"
      end
    end

    context "when a user is not logged in" do
      it "redirects to log in page" do
        post follows_path(following_id: follow_user.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE" do
    let(:follow) { create(:follow, follower: user) }
    context "when a user is logged in" do
      before { sign_in user }

      it "deletes an instance of a follow" do
        delete follow_path(id: follow.id)
        follow_instance = Follow.find_by(follower_id: user.id, following_id: follow.following.id)
        expect(follow_instance).to be_nil
      end
    end

    context "when a user is not logged in" do
      it "redirects to log in page" do
        delete follow_path(id: follow.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
