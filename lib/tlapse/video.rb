module Tlapse
  class Video
    attr_accessor *%i(size framerate codec outfile)

    def initialize(opts)
      @codec = opts.fetch(:codec, "libx264")
      @framerate = opts.fetch(:framerate, "60")
      @glob = opts.fetch(:glob, "**/*.jpg")
      @outfile = opts.fetch(:out, "out.mkv")
      @size = opts.fetch(:size, "1920x1080")
    end

    def create_command
      command = "ffmpeg"
      command += " -pattern_type glob"
      command += " -i '#{@glob}'"
      command += " -s #{@size}"
      command += " -r #{@framerate}"
      command += " -vcodec #{@codec}"
      command += " #{@outfile}"
      command
    end

    def create!
      cmd = create_command
      puts cmd
      exec cmd
    end

    def outfile_exists?
      File.exist? @outfile
    end
  end
end
