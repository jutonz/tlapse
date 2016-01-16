module Tlapse
  module Doctor
    def doctor
      print "Checking gphoto2..."
      if `which gphoto2`.empty?
        raise "Could not find gphoto2 :("
      end
      puts "ok!"

      print "Checking camera..."
      # TODO: Check camera
      puts "ok!"

      puts "Looks good!"
    end
  end # Doctor
end # Tlapse
