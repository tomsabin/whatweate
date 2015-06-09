ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "shoulda/matchers"
require "webmock/rspec"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

ActiveRecord::Migration.maintain_test_schema!

Delayed::Worker.delay_jobs = false

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
end
