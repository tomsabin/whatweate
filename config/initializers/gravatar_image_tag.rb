GravatarImageTag.configure do |config|
  config.default_image = ENV["GRAVATAR_DEFAULT_ICON_URL"]
  config.include_size_attributes = true
  config.size = 200
end
