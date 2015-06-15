source "https://rubygems.org"

gem "rails", "4.2.1"
gem "pg"
gem "puma"
gem "uglifier"
gem "sass-rails"
gem "jquery-rails"
gem "turbolinks"
gem "rails_config"
gem "devise"
gem "gravatar_image_tag"
gem "simple_form"
gem "omniauth"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem "draper"
gem "rollbar"
gem "money-rails"
gem "redcarpet"
gem "aasm"
gem "wisper"
gem "delayed_job_active_record"
gem "validate_url"
gem "slack-notifier"
gem "wisper-activerecord"
gem "friendly_id"
gem "stripe"
gem "date_time_attribute"
gem "carrierwave", github: "carrierwaveuploader/carrierwave", ref: "de2a955"
gem "mini_magick"
gem "jquery-turbolinks"

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem "rspec-rails", "~> 3.0"
  gem "pry"
  gem "factory_girl_rails"
  gem "faker"
  gem "letter_opener"
  gem "dotenv-rails"
end

group :development do
  gem "spring"
  gem "rubocop"
end

group :test do
  gem "capybara"
  gem "poltergeist"
  gem "shoulda-matchers"
  gem "codeclimate-test-reporter", require: nil
  gem "wisper-rspec", require: false
  gem "webmock"
  gem "vcr"
  gem "test_after_commit"
  gem "database_cleaner"
end

ruby "2.2.2"
