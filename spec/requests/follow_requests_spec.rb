require 'rails_helper'

RSpec.describe "FollowRequests", type: :request do
  let(:user) { create(:user) }
  let(:follow) { create(:follow, follower: user) }

  before { sign_in user }

  describe "UPDATE" do
    it "updates follow to accepted" do
      patch follow_request_path(id: follow.id)

      follow_status = follow.reload.status
      expect(follow_status).to eq "accepted"
    end
  end

  describe "DELETE" do
    it "removes follow request" do
      delete follow_request_path(id: follow.id)

      expect { Follow.find(follow.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
