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
end
