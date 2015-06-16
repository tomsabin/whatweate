class AdminMessengerJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    AdminMessenger.broadcast(*args)
  end
end
