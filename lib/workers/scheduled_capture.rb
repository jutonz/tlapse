Sidekiq.configure_client do |config|
  config.redis = { namespace: "tlapse", size: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: "tlapse" }
end

class ScheduledCapture
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    puts "hey it worked"
  end
end
