module Tlapse
  ##
  # Run tlapse in automatic mode, which will start capturing automatically
  # every day at sunrise, continuing until sunset.
  class Automatic
    def initialize
      sunrise = SolarEvent.sunrise
      now = Time.now
      start_time = now > sunrise ? now : sunrise

      #ScheduledCapture.perform_at(start_time)
      ScheduledCapture.perform_async
    end
  end # Automatic
end # Tlapse
