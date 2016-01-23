module Tlapse
  module Doctor
    def doctor
      print "Checking gphoto2..."
      check_gphoto2!
      puts "ok!"

      print "Checking camera..."
      check_camera!
      puts "ok!"

      puts "Looks good!"
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
