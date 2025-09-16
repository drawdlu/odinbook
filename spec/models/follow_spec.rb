require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "Following users" do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }

    context "when follow instantiated from a follower object" do
      it "will create follow instance pending approval" do
        user_1.followings<<(user_2)
        follow = Follow.find_by(follower_id: user_1.id, following_id: user_2.id)
        expect(user_1.followings).to include(user_2)
        expect(user_2.followers).to include(user_1)
        expect(follow.status).to eq "pending"
      end
    end

    context "when follow instantiated from a following object" do
      it "will create follow instance pending approval" do
        user_1.followers<<(user_2)
        follow = Follow.find_by(follower_id: user_2.id, following_id: user_1.id)
        expect(user_1.followers).to include(user_2)
        expect(user_2.followings).to include(user_1)
        expect(follow.status).to eq "pending"
      end
    end

    context "when trying to follow twice" do
      it "will raise an error at model level validation" do
        user_1.followings<<(user_2)
        expect do
          user_1.followings<<(user_2)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "will raise an error at database level validation" do
        user_1.followings<<(user_2)
        duplicate_follow = user_1.followed_users.build(following_id: user_2.id)
        expect do
          duplicate_follow.save(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
