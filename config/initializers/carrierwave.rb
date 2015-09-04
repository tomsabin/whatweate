CarrierWave.configure do |config|
  if Rails.env.test?
    config.permissions = 0644
    config.storage     = :file
    config.root        = Rails.root.join("tmp")
  elsif Rails.env.development?
    config.permissions = 0644
    config.storage     = :file
  else
    config.storage    = :aws
    config.aws_bucket = ENV["AWS_S3_BUCKET_NAME"]
    config.aws_acl    = 'public-read'
    config.aws_credentials = {
      access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region:            ENV["AWS_REGION"]
    }
  end
end
