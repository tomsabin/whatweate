require 'slack-notifier'

class AdminMessenger
  def self.broadcast(message)
    new.broadcast(message)
  end

  def initialize
    @notifier = Slack::Notifier.new("WEBHOOK_URL", channel: "#notifications", username: "WhatWeAte")
  end

  def broadcast(message)
    @notifier.ping(message)
  end
end
