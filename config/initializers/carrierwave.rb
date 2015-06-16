CarrierWave.configure do |config|
  config.permissions = 0644
  config.storage = :file
  config.root = Rails.root.join("tmp") if Rails.env.test?
end
