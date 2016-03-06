require "active_support/core_ext/numeric/time.rb"

module Tlapse
  module Capture
    def self.capture_single
      `gphoto2 --capture-image-and-download`
    end

    def self.captures_needed(start_time: Time.now, end_time: Time.now,
                             duration: nil, interval:)
      unless duration
        start_time = start_time.to_i
        end_time   = end_time.to_i
        duration   = end_time - start_time
      end

      duration / interval
    end
  end # Capture
end # Tlapse
