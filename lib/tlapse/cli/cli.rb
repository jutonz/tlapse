require "thor"
require "active_support/core_ext/numeric/time.rb"
require "tlapse"
require "tlapse/cli/alpha"

module Tlapse::CLI
  class CLI < Thor
    desc "doctor", "Perform checks to see if you're ready to tlapse"
    def doctor
      Tlapse::Doctor.doctor
    end

    desc "version", "Print the version number and exit"
    def version
      puts Tlapse::VERSION
    end

    desc "capture", "Capture a single photo, saving it to the current directory"
    def capture
      Tlapse::Capture.capture_single
    end

    desc "until_sunset", "Generate a gphoto2 command to capture photos from now until the sun sets (useful for cronjobs)"
    option :interval,
      desc: "The interval (in minutes) at which picturs will be taken",
      type: :numeric,
      default: 5,
      aliases: %i(i)
    def until_sunset
      interval = options[:interval].minutes
      puts Tlapse::Capture.timelapse_command_while_sun_is_up(interval: interval)
    end

    desc "alpha", "Get early access to in-development (and likely unstable) commands"
    subcommand "alpha", Tlapse::CLI::Alpha
  end
end
