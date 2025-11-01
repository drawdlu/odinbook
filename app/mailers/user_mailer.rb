class UserMailer < ApplicationMailer
  default from: "odincreate@gmail.com"

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Successfully Signed Up to Odinbook!")
  end
end
