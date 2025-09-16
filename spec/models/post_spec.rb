require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Post creation" do
    context "when complete and valid params" do
      let(:valid_post) { build(:post) }
      it "will be valid" do
        expect(valid_post).to be_valid
      end

      it "will have a valid user reference" do
        expect(valid_post.user).to be_valid
      end
    end

    context "when missing body text" do
      it "will be invalid when missing body text" do
        new_post = build(:post, body: "")
        expect(new_post).to_not be_valid
      end
    end

    context "when missing a user reference" do
      it "will be invalid when missing user reference" do
        new_post = build(:post, user: nil)
        expect(new_post).to_not be_valid
      end
    end

    context "when using helper methods with user" do
      let(:user) { create(:user) }
      it "will create a new post" do
        post = user.posts.build(body: "test")
        expect(post).to be_valid
      end

      it "can create multiple posts" do
        post_1 = user.posts.build(body: "test")
        post_2 = user.posts.build(body: "test")
        expect(post_1).to be_valid
        expect(post_2).to be_valid
      end
    end
  end
end
