require 'rails_helper'

RSpec.describe "Follows::Followers", type: :request do
  let(:user) { create(:user) }
  let(:follower_user) { create(:user) }
  let(:follow) { create(:follow, follower: follower_user, following: user, status: 1) }

  before { sign_in user }

  describe "GET /index" do
    it "returns followers page" do
      get user_followers_path(user_id: user.id)

      expect(response).to be_successful
    end
  end

  describe "POST" do
    it "creates a follow request to follower_user" do
      post user_followers_path(user),
      params: { follower_id: follower_user.id, follow_id: follow.id },
      as: :turbo_stream

      follow_request = Follow.find_by(follower_id: user.id, following_id: follower_user.id, status: 0)

      expect(follow_request).to_not be_nil
      expect(response).to be_successful
    end
  end

  describe "DELETE" do
    it "removes a follow request" do
      follow_request = user.followed_users.create(following_id: follower_user.id)

      delete user_follower_path(user_id: user.id, id: follow_request.id),
      params: { follow_id: follow.id },
      as: :turbo_stream

      expect { Follow.find(follow_request.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "removes a follow request" do
      follow_accepted = user.followed_users.create(following_id: follower_user.id, status: 1)

      delete user_follower_path(user_id: user.id, id: follow_accepted.id),
      params: { follow_id: follow.id },
      as: :turbo_stream

      expect { Follow.find(follow_accepted.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
