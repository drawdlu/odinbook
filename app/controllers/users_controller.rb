class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.includes(:followers, :follower_users).all_except(current_user)
  end
end
