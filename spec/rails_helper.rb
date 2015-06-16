ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "shoulda/matchers"
require "webmock/rspec"
require "vcr"
require "carrierwave/test/matchers"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_run_excluding :smoke

  config.include Devise::TestHelpers, type: :controller
  config.include CarrierWave::Test::Matchers, type: :uploader

  config.around(:example, :smoke) do |example|
    WebMock.allow_net_connect!
    VCR.turned_off { example.run }
    WebMock.disable_net_connect!
  end

  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join("tmp", CarrierWave::Uploader::Base.cache_dir))
    FileUtils.rm_rf(Rails.root.join("tmp", CarrierWave::Uploader::Base.store_dir))
  end
end
