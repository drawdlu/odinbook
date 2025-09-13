require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User creation" do
    context "when complete valid params" do
      it "will be valid" do
        new_user = build(:user)
        expect(new_user).to be_valid
      end
    end

    context "when missing username" do
      it "will be invalid" do
        new_user = build(:user, username: nil)
        expect(new_user).to_not be_valid
      end
    end

    context "when username has a duplicate" do
      it "will raise an error when username has a duplicate" do
        new_user = create(:user)
          expect do
              create(:user, username: new_user.username)
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
  end

  describe "User post creation" do
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
