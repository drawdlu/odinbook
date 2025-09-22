class LikesController < ApplicationController
  before_action :authenticate_user!

  def new
    @like = Like.new
  end

  def create
    @post = Post.find(like_params[:post_id])
    @like = Like.new(post_id: like_params[:post_id], user_id: current_user.id)

    @like.save

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = Like.find(params[:id])

    @like.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
