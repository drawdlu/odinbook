class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @follow = current_user.followed_users.build(follow_params)

    @follow.save
  end

  def destroy
    @follow = Follow.find(params[:id])

    @follow.destroy
  end

  private

  def follow_params
    params.permit(:following_id)
  end
end
