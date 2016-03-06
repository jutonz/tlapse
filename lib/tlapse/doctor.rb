module Tlapse
  module Doctor
    CHECKS = %i(gphoto2 camera)

    def doctor
      CHECKS.each do |check|
        print "Checking #{check}..."
        send "check_#{check}!"
        puts "ok!"
      end

      puts "Looks good!"
    end

    def okay?
      CHECKS.each { |check| send "check_#{check}!" }
      true
    rescue StandardError
      false
    end

    private ###################################################################

    def check_gphoto2!
      raise "Could not find gphoto2 :(" if `which gphoto2`.empty?
    end

    def check_camera!
      cameras = `gphoto2 --auto-detect`

      # Output looks like this:
      #
      #   Model       Port
      #   --------------------
      #   Camera      :usb
      #
      # If there is a third line, a camera was detected

      unless cameras.split("\n").length > 2
        raise "gphoto2 couldn't find a camera :("
      end
    end
  end # Doctor
end # Tlapse
