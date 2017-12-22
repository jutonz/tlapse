require "fileutils"

module Tlapse
  class Util
    def self.organize!(dry_run: false)
      Dir["*.jpg"].each do |filename|
        normalize_path! filename, dry_run: dry_run
      end
    end

    def self.normalize_path!(file, dry_run: false)
      dirname = normalized_dirname(file)
      FileUtils.mkdir dirname unless File.exist? dirname || dry_run

      filename = normalized_filename(file)
      path = File.join dirname, filename

      puts "Rename #{file} to #{path}"
      FileUtils.mv file, path unless dry_run
    end

    def self.normalized_dirname(file)
      File.mtime(file).strftime(Tlapse::Capture.capture_dirname)
    end

    def self.normalized_filename(file)
      File.mtime(file).strftime(Tlapse::Capture.capture_filename)
    end
  end
end
