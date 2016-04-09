require "active_support/core_ext/numeric/time.rb"

module Tlapse
  module Capture
    def self.capture_single(format: nil)
      puts "The format key is not yet supported" if format

      `gphoto2 --capture-image-and-download`
    end

    ##
    # Calculate how many captures are needed given a duration of capture
    # time and a desired interval between captures.
    #
    # @example
    #   captures_needed duration: 5.minutes, interval: 30.seconds # => 10
    #
    # Specify either `start_time` and `end_time` or `duration`. If both
    # are given, `duration` is preferred.
    #
    # @param start_time: [Time] when to start capturing
    # @param end_time: [Time] when to end capturing
    # @param duration: [Duration] duration over which images are captured.
    #  If specifying, do not also specify `end_time
    # @param interval: [Duration] time between each capture
    # @return how many captures will be taken over the duration and interval
    def self.captures_needed(start_time: Time.now, end_time: Time.now,
                             duration: nil, interval:)
      unless duration
        start_time = start_time.to_i
        end_time   = end_time.to_i
        duration   = end_time - start_time
      end

      duration / interval
    end

    ##
    # Capture a series of timelapse images over the given duration
    # and at the given interval.
    #
    # @return [String] a gphoto2 command with the desired arguments
    def self.timelapse_command(from: Time.now, to:, interval:)
      captures = self.captures_needed(
        start_time: from,
        end_time:   to,
        interval:   interval
      )
      "gphoto2 --capture-image-and-download -I #{interval} -F #{captures}"
    end

    ##
    # Capture a timelapse image once per interval while the sun is up.
    #
    # @param interval [Duration] how frequently to capture images
    # @return [String] a gphoto2 command with the desired arguments
    def self.timelapse_command_while_sun_is_up(interval: 5.minutes)
      sunrise = SolarEvent.sunrise
      sunset  = SolarEvent.sunset
      now     = Time.now

      # Use now as starting time if sunrise has passed
      sunrise = now > sunrise ? now : sunrise

      captures = self.captures_needed(
        start_time: sunrise,
        end_time:   sunset,
        interval:   interval
      )
      "gphoto2 --capture-image-and-download -I #{interval} -F #{captures}"
    end
  end # Capture
end # Tlapse
