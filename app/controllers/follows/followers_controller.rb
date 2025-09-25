module Follows
  class FollowersController < ApplicationController
    def index
      @followed_user = User.find(params[:user_id])
      @followers = @followed_user.follower_instances.includes(:follower)
    end

    def create
      @follow_reference = Follow.find(params[:follow_id])
      @follow = current_user.followed_users.build(following_id: params[:follower_id])

      @follow.save

      respond_to do |format|
        format.turbo_stream
      end
    end

    def destroy
      @follow_reference = Follow.find(params[:follow_id])
      @follow = Follow.find(params[:id])

      @follow.destroy

      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
