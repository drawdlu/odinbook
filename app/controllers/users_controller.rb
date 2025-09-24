class UsersController < ApplicationController
  include RequiresUsername

  def index
    @users = User.includes(:followers, :follower_users).all_except(current_user)
  end
end
