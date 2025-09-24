module UsernamesHelper
  def redirect_user(user, new)
    if new
      flash[:notice] = "Successfully signed up using Google"
      redirect_to root_path
    else
      # redirect to profile page, does not exist yet
    end
  end
end
