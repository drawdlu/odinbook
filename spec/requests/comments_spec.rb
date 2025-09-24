require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:comment) { create(:comment, user: user) }
  let(:body) { "DifferentString" }

  describe "POST" do
    context "when user is signed in" do
      before { sign_in user }

      it "creates a comment by user" do
        post post_comments_path(post_id: comment.post_id),
              params: { comment: { body: body, user_id: user.id } }
        new_comment = Comment.find_by(post_id: comment.post_id,
                                      body: body,
                                      user_id: user.id)

        expect(new_comment).to_not be_nil
      end
    end

    context "when user is not signed in" do
      it "will redirect to sign in path" do
        post post_comments_path(post_id: comment.post_id),
              params: { comment: { body: body, user_id: user.id } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE" do
    context "when user is signed in" do
      before { sign_in user }
      it "deletes the comment" do
        delete post_comment_path(post_id: comment.post_id, id: comment.id)

        expect { Comment.find(comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is not signed in" do
      it "fails and redirects to sign in path" do
        delete post_comment_path(post_id: comment.post_id, id: comment.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
