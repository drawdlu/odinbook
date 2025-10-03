class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @posts = @user.posts.includes(:likes, :comments)
  end
end
