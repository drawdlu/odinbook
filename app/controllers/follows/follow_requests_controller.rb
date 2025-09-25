module Follows
  class FollowRequestsController < ApplicationController
    def index
      @follow_requests = current_user.follow_requests.includes(:follower)
    end

    def update
      @follow = Follow.find(params[:id])

      @follow.update(status: 1)

      respond_to do |format|
        format.turbo_stream
      end
    end

    def destroy
      @follow = Follow.find(params[:id])

      @follow.destroy

      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
