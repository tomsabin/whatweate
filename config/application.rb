require File.expand_path("../boot", __FILE__)
require "rails/all"

Bundler.require(*Rails.groups)

module WhatWeAte
  class Application < Rails::Application
    config.exceptions_app = self.routes
  end
end
