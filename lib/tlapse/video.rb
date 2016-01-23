module Tlapse
  class Video

    attr_accessor *%i(size framerate codec outfile)

    def initialize(opts)
      @size      = opts.fetch :size,      "1920x1080"
      @framerate = opts.fetch :framerate, "60"
      @codec     = opts.fetch :codec,     "libx264"
      @outfile   = opts.fetch :out,       "out.mkv"
    end

    def create!
      command = "ffmpeg"
      command += " -pattern_type glob"
      command += " -i '*.jpg'"
      command += " -s #{@size}"
      command += " -r #{@framerate}"
      command += " -vcodec #{@codec}"
      command += " #{@outfile}"
      puts command
      exec command
    end

    ##
    # @return whether the output file already exists
    def outfile_exists?
      File.exist? @outfile
    end

  end # Video
end # Tlapse
