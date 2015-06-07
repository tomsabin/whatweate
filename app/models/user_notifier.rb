class UserNotifier
  def create_host_successful(host)
    UserMailer.new_host(host.user).deliver_later
  end
end
