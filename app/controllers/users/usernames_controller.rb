module Users
  class UsernamesController < ApplicationController
    include UsernamesHelper
    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
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
