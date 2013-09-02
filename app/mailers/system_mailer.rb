class SystemMailer < ActionMailer::Base
  default from: ENV["SYSTEM_FROM_EMAIL"]

  def new_user_email(user)
  	@user = user
  	mail(to: ENV["SYSTEM_EMAIL"], subject: 'New user registration')
  end
end
