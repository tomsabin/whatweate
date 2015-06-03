if Rails.env.development?
  FactoryGirl.create(:user, email: "user@example.com", password: "letmein!!")
  FactoryGirl.create(:admin, email: "admin@example.com", password: "letmein!!")
end
