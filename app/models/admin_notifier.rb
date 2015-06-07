require 'slack-notifier'

class AdminNotifier
  def self.notify(message)
    new.notify(message)
  end

  def initialize
    @notifier = Slack::Notifier.new("WEBHOOK_URL", channel: "#notifications", username: "WhatWeAte")
  end

  def notify(message)
    @notifier.ping(message)
  end
end
