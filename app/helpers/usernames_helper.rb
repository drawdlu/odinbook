module UsernamesHelper
  def redirect_user(user)
    if user_signed_in?
      # redirect to profile page, which does not exist yet
    else
      flash[:notice] = "Successfully signed up using Google"
      sign_in_and_redirect user, event: :authentication
    end
  end
end
