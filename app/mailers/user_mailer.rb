class UserMailer < ApplicationMailer
  def new_host(user)
    mail(to: user.email, subject: "New host")
  end
end
