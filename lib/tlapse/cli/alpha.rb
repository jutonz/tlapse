require "thor"
require "rainbow"
require "fileutils"

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

    desc "compile", "Use ffmpeg to combine .jpg"
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
    option :glob,
      desc: "Specify how to find input images, e.g. `*.JPEG`",
      type: :string,
      default: "**/*.jpg"
    def compile
      video = Tlapse::Video.new(
        glob: options[:glob],
        out: options[:out]
      )

      if video.outfile_exists?
        if options[:force]
          FileUtils.rm(video.outfile)
          puts "Removed file #{video.outfile}"
        else
          Tlapse::Logger.error! "#{video.outfile} exists. Use -f to overwrite or " \
            "-o to specify a different output file."
        end
      end

      video.create!
    end

    desc "organize", "Cannonically organize pictures in the current directory"
    option :dry_run,
      desc: "Print out what would change without actually changing anything",
      type: :boolean,
      default: false
    def organize
      Tlapse::Util.organize! dry_run: options[:dry_run]
    end

    desc "capture", "Capture a series of timelapse photos"
    option :interval,
      desc: "The interval (in minutes) at which pictures will be taken",
      type: :numeric,
      default: 5,
      aliases: %i(i)
    option :until,
      desc: %(Time to stop capturing. Can use special "sunset" or "sunrise"),
      type: :string,
      default: "sunset"
    option :compile,
      desc: "When done capturing, compile photos into a video",
      type: :boolean,
      default: false
    option :compile_out,
      desc: "Specify the name for the generated video file",
      type: :string,
      default: "out.mkv"
    def capture
      dirname = Time.now.strftime(Tlapse::Capture.capture_dirname)
      FileUtils.mkdir_p dirname
      Dir.chdir dirname

      cmd = Tlapse::Capture.timelapse_command(
        to: parse_time(options[:until]),
        interval: options[:interval].minutes
      )

      if options[:compile]
        video = Tlapse::Video.new(
          outfile: options[:compile_out]
        )

        if video.outfile_exists?
          Tlapse::Logger.error! "The file #{video.outfile} already exists in" \
            " the directory #{dirname}. Please delete it or use the" \
            " --compile-out option to specify a different filename."
        end

        cmd += " && #{video.create_command}"
      end

      exec cmd
    end

    no_commands do
      def parse_time(time)
        case time
        when "sunset" then Tlapse::SolarEvent.sunset
        when "sunrise" then Tlapse::SolarEvent.sunrise
        else Time.parse(time)
        end
      end
    end
  end
end
