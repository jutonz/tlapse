class ScheduledCapture
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    puts "hey it worked"
  end
end
