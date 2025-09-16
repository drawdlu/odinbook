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
      let(:new_user) { create(:user) }
      let(:duplicate_user) { build(:user, username: new_user.username) }
      it "will raise an error at model validation level" do
          expect do
              duplicate_user.save!
          end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "will raise an error at database level" do
        expect do
          duplicate_user.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
