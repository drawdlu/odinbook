require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post) }

  describe "POST" do
    context "when user is logged in" do
      before { sign_in user }
      it "creates a like instance for that post" do
        post likes_path(post_id: post_record.id)
        new_like = Like.find_by(post_id: post_record.id, user_id: user.id)
        expect(new_like).to_not be_nil
      end
    end

    context "when user is not loggen in" do
      it "redirects to sign in page" do
        post likes_path(post_id: post_record.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE" do
    let(:comment) { create(:comment, user: user, post: post_record) }
    context "when user is signed in" do
      before { sign_in user }

      it "deletes the like" do
        delete like_path(id: comment.id)

        expect { Like.find(comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        delete like_path(id: comment.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
