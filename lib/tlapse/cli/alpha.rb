require "thor"

module Tlapse::CLI
  class Alpha < Thor
    desc "serve", "Start a drb server via which photo capturing may be performed remotely"
    option :host,
      desc: "The hostname on which the server is run",
      type: :string,
      default: "localhost",
      aliases: %i(H)
    option :port,
      desc: "The port on which the server is run",
      type: :numeric,
      default: 9000,
      aliases: %i(p)
    def serve
      server = Tlapse::Server.new(
        host: options[:host],
        port: options[:port]
      )
      puts "Serving on #{server.full_host}"
      server.serve
    end

    desc "compile", "Use ffmpeg to combine all .jpg files in the current directory"
    option :force,
      desc: "Force overwrite any existing output files",
      type: :boolean,
      default: false,
      aliases: %i(f)
    option :out,
      desc: "The desired output filename",
      type: :string,
      default: "out.mkv",
      aliases: %i(o)
    def compile
      video = Video.new out: options[:out]

      if video.outfile_exists?
        if options[:force]
          FileUtils.rm video.outfile
          puts "Removed file #{video.outfile}"
        else
          raise "#{video.outfile} exists. Use -f to overwrite or " \
            "-o to specify a different output file."
        end
      end

      video.create!
    end
  end
end
