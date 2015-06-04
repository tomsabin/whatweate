Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_files = false
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = { :host => ENV["MAILER_HOST"] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV["MAILER_ADDRESS"],
    port:                 ENV["MAILER_PORT"],
    domain:               ENV["MAILER_DOMAIN"],
    user_name:            ENV["MAILER_USER_NAME"],
    password:             ENV["MAILER_PASSWORD"],
    authentication:       ENV["MAILER_AUTHENTICATION"],
    enable_starttls_auto: true  }
end
