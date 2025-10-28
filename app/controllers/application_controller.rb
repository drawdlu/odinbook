class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_current_user

  include RequiresUsername

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :username ])
  end

  def set_current_user
    Current.user = current_user
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
