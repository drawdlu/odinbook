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

    context "when username length is incorrect" do
      it "will be invalid if it is less than 4" do
        new_user = build(:user, username: "not")
        expect(new_user).to_not be_valid
      end

      it "will be invalid if it is greater than 32" do
        new_user = build(:user, username: Faker::Internet.username(specifier: 33))
        expect(new_user).to_not be_valid
      end
    end

    context "when username contains a whitespace" do
      it "will be invalid" do
        new_user = build(:user, username: "test test")
        expect(new_user).to_not be_valid
      end
    end
  end

  describe "profile image creation" do
    let(:user) { create(:user) }
    it "creates a profile image from gravatar" do
      expect(user.profile.image).to_not be_nil
    end
  end
end
