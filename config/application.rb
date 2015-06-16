require File.expand_path("../boot", __FILE__)
require "rails/all"
Bundler.require(*Rails.groups)
require "carrierwave/orm/activerecord"

module WhatWeAte
  class Application < Rails::Application
    config.exceptions_app = self.routes
    config.active_job.queue_adapter = :sidekiq
    config.active_record.raise_in_transactional_callbacks = true
  end
end
