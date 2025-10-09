module RequiresUsername
  extend ActiveSupport::Concern

  included do
    before_action :has_username, unless: :devise_controller?
  end

  private

  def has_username
    if user_signed_in? && current_user.username.nil?
      @show_nav = false
      redirect_to edit_username_path
    elsif user_signed_in?
      @show_nav = true
    else
      @show_nav = false
    end
  end
end
