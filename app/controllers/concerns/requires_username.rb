module RequiresUsername
  extend ActiveSupport::Concern

  included do
    before_action :has_username
  end

  private

  def has_username
    if user_signed_in? && current_user.username.nil?
      @show_nav = false
      redirect_to edit_username_path
    else
      @show_nav = true
    end
  end
end
