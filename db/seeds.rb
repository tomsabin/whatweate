if Rails.env.development?
  Admin.find_or_create_by(email: "admin@example.com")
    .update(FactoryGirl.attributes_for(:admin).merge(password: "letmein!!").except(:email))
  User.find_or_create_by(email: "user@example.com")
    .update(FactoryGirl.attributes_for(:user).merge(password: "letmein!!").except(:email))
  User.find_or_create_by(email: "host@example.com")
    .update(FactoryGirl.attributes_for(:user).merge(password: "letmein!!").except(:email))
  Host.find_or_create_by(name: "Event host")
    .update(user: User.find_by(email: "host@example.com"))
  Event.find_or_create_by(title: "Event title")
    .update(FactoryGirl.attributes_for(:event).merge(host: Host.find_by(name: "Event host")).except(:title))
end
