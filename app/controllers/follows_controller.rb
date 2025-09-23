class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(follow_params[:following_id])
    @follow = current_user.followed_users.build(follow_params)

    @follow.save

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @follow = Follow.find(params[:id])
    @user = User.find(@follow.following_id)

    @follow.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def follow_params
    params.permit(:following_id)
  end
end
