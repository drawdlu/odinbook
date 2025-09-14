require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "Liking posts" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    it "will add user to post likes" do
      user.liked_posts<<(post)
      expect(post.user_likes).to include(user)
    end

    it "will add post to user likes" do
      post.user_likes<<(user)
      expect(user.liked_posts).to include(post)
    end
  end
end
