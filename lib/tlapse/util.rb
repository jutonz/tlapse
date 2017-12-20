require "fileutils"

module Tlapse
  class Util
    def self.normalize!(dry_run: false)
      Dir["*.jpg"].each do |filename|
        normalized = normalize_filename(filename)
        if filename != normalized
          puts "Rename #{filename} to #{normalized}"
          FileUtils.mv filename, normalize_filename unless dry_run
        end
      end
    end

    def self.normalize_filename(file)
      File.mtime(file).strftime(Tlapse::Capture::CAPTURE_FILENAME)
    end
  end
end
