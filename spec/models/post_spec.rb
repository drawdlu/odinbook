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
  end
end
