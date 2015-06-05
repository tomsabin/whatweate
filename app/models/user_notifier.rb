class UserNotifier
  def initialize(user)
    @user = user
  end

  def new_host
    UserMailer.new_host(@user).deliver_later
  end
end
