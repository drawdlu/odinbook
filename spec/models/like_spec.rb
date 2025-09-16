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

    context "when same user likes a post twice" do
      it "will raise error at model validation level" do
        user.liked_posts<<(post)
        expect do
          user.liked_posts<<(post)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "will raise an error at database level" do
        user.liked_posts<<(post)
        like = user.likes.build(post_id: post.id)
        expect do
          like.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
