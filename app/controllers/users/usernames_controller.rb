module Users
  class UsernamesController < ApplicationController
    include UsernamesHelper
    skip_before_action :has_username

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      new = @user.username == nil ? true : false

      if @user.update(username_params)
        redirect_user(@user, new)
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def username_params
      params.require(:user).permit(:username)
    end
  end
end
