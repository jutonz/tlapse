module Tlapse
  module Capture
    def capture_single
      `gphoto2 --capture-image-and-download`
    end
  end # Capture
end # Tlapse
