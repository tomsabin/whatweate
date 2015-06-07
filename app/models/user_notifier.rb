class UserNotifier
  def new_host(user)
    UserMailer.new_host(user).deliver_later
  end
end
