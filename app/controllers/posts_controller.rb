class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    user_ids = current_user.followings.map(&:id) << current_user.id
    @posts = Post.includes(:user).where(user_id: user_ids)
  end
end
