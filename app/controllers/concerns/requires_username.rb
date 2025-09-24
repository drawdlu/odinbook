module RequiresUsername
  extend ActiveSupport::Concern

  included do
    before_action :has_username
  end

  private

  def has_username
    if current_user.username.nil?
      redirect_to usernames_edit_user_path(id: current_user.id)
    end
  end
end
