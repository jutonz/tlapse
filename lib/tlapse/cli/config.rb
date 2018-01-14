require "thor"
require "tlapse/config"

module Tlapse::CLI
  class Config < Thor
    desc "list", "List available configuration options"
    def list

    end

    desc "get OPTION", "Get the value for the given config option"
    def get(option)
      Tlapse::Config.get option
    rescue Tlapse::NoSuchConfigOption
      Tlapse::Logger.error! "The config option #{option} does not exist. Run " \
        "tlapse config list for a full list of available options"
    end

    desc "set OPTION VALUE", "Set the given config option to the given value"
    def set(option, value)

    end
  end
end
