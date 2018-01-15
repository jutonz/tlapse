require "thor"
require "tlapse/config"

module Tlapse::CLI
  class Config < Thor
    desc "list", "List available configuration options"
    def list
      config = Tlapse::Config.list.dup
      opts = config.keys

      values = Tlapse::Config.get *opts

      config = config.transform_values.with_index do |original, index|
        default = original[:default]
        default = default.call if default.respond_to? :call
        original[:default] = default

        original[:value] = values[index].to_s

        original
      end

      # Make a simple table.
      max_name = opts.max_by(&:length).length
      max_desc = opts.max_by { |opt| config[opt][:desc].length }
      max_desc = config[max_desc][:desc].length
      max_value = opts.max_by { |opt| config[opt][:value].length }
      max_value = config[max_value][:value].length

      config.each_pair do |option, meta|
        desc, default = meta.values_at :desc, :default
        name_padded   = option.ljust(max_name, " ")
        desc_padded   = meta[:desc].ljust(max_desc, " ")
        #value_padded  = meta[:value].ljust(max_value, " ")
        value_padded = meta[:value]

        puts "#{name_padded} -> #{desc_padded} -> #{value_padded} (default: #{default})"
      end
    end

    desc "get OPTION", "Get the value for the given config option"
    def get(*options)
      puts Tlapse::Config.get *options
    rescue Tlapse::NoSuchConfigOption
      Tlapse::Logger.error! "The config option \"#{option}\" does not exist. " \
        "Run tlapse config list for a full list of available options"
    end

    desc "set OPTION VALUE", "Set the given config option to the given value"
    def set(option, value)
      Tlapse::Config.set option, value
    rescue Tlapse::NoSuchConfigOption
      Tlapse::Logger.error! "The config option \"#{option}\" does not exist. " \
        "Run tlapse config list for a full list of available options"
    rescue Tlapse::ConfigOptionInvalid => invalid
      Tlapse::Logger.error! invalid.message
    end

    desc "unset OPTION", "Restore the given option to its default state"
    def unset(option)
      Tlapse::Config.unset option
    rescue Tlapse::NoSuchConfigOption
      Tlapse::Logger.error! "The config option \"#{option}\" does not exist. " \
        "Run tlapse config list for a full list of available options"
    end
  end
end
