require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "commenting on posts" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:string) { "string" }

    it "creates comment association to a user" do
      post.comments.create(body: string, user_id: user.id)
      expect(post.commenting_users).to include(user)
    end

    it "creates comment association to post" do
      user.comments.create(body: string, post_id: post.id)
      expect(user.commented_posts).to include(post)
    end
  end
end
