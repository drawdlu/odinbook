class Follows::FollowingsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @followings = @user.following_instances.includes(:following)
  end
end
