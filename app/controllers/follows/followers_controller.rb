module Follows
  class FollowersController < ApplicationController
    def index
      @followed_user = User.find(params[:user_id])
      @followers = @followed_user.follower_instances.includes(:follower)
    end
  end
end
