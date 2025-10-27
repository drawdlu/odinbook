class UsersController < ApplicationController
  def index
    @users = User.includes(:followers, :follower_users).all_except(current_user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(current_user.id)

    # if @user.update(user_params)
    #   redirect_to user_profile_path(user_id: @user.id)
    # else
    #   render :edit, status: :unprocessable_entity
    # end

    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream
        format.html { redirect_to user_profile_path(user_id: @user.id) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.expect(user: [ :username, :email, profile_attributes: [ :image, :about, :id ] ])
  end
end
