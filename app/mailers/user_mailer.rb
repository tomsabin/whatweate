class UserMailer < ApplicationMailer
  default template_path: "users/mailer"

  def new_host(user)
    mail(to: user.email, subject: "New host")
  end

  def booking_receipt(user, event)
    @user_full_name = user.full_name
    @event = event.decorate
    @booking_total_payment = event.price.format
    mail(to: user.email, subject: "Your receipt for #{event.title}")
  end
end
