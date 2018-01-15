require "yaml"
require "fileutils"
require "tlapse/errors"
require "active_support/time_with_zone"

module Tlapse
  class Config
    Validation = Struct.new :method, :error

    CONFIG_OPTIONS = {
      "lat" => {
        default: 35.779590,
        desc: "Your current latitude",
        type: :float
      },
      "lon" => {
        default: -78.638179,
        desc: "Your current longitude",
        type: :float
      },
      "tz" => {
        default: -> { Tlapse::Config.current_tz },
        desc: "Your current timezone",
        type: :string,
        validations: [
          Validation.new(
            ->(tz) { TZInfo::Timezone.get(tz) },
            ->(tz) do
              zones = ActiveSupport::TimeZone.all.map do |tz|
                tz.tzinfo.name
              end.uniq.sort.join("\n")

              "#{tz} is not a valid timezone. Valid zones are:\n\n#{zones}"
            end
          )
        ]
      }
    }.freeze

    CONFIG_KEYS = CONFIG_OPTIONS.keys.freeze

    CONFIG_PATH = File.expand_path ".config/tlapse/tlapse.yaml", Dir.home

    CONFIG_UNDEFINED = :undefined

    def self.list
      CONFIG_OPTIONS
    end

    def self.get(*options)
      values = Array(options).map do |option|
        verify_option_exists! option

        value = value_for option
        value == CONFIG_UNDEFINED ? default_for(option) : value
      end

      values.length == 1 ? values.first : values
    end

    def self.set(option, value)
      verify_option_exists! option
      validate! option, value

      values = user_values

      if value == default_for(option)
        values.delete option
      else
        values[option] = value
      end

      save values
    end

    def self.unset(option)
      set option, default_for(option)
    end

    private

    def self.current_tz
      utc_offset = Time.now.utc_offset
      tz = ActiveSupport::TimeZone.all.find { |tz| tz.utc_offset == utc_offset }
      tz&.tzinfo&.name || "America/New_York"
    end

    def self.cast(option, value)
      case type_for(option)
      when :integer then value.to_i
      when :float   then value.to_f
      when :string  then value.to_s
      else value
      end
    end

    def self.verify_option_exists!(option)
      raise Tlapse::NoSuchConfigOption unless CONFIG_KEYS.include? option
    end

    def self.value_for(option)
      value = user_values[option]
      value ? cast(option, value) : CONFIG_UNDEFINED
    end

    def self.default_for(option)
      default = CONFIG_OPTIONS.dig option, :default
      default = default.call if default.respond_to? :call
      cast option, default
    end

    def self.type_for(option)
      CONFIG_OPTIONS.dig option, :type
    end

    def self.user_values
      File.exists?(CONFIG_PATH) ? YAML.load_file(CONFIG_PATH) : {}
    end

    def self.save(user_values)
      FileUtils.mkdir_p File.dirname CONFIG_PATH
      File.write CONFIG_PATH, user_values.to_yaml
    end

    def self.validate!(option, value)
      Array(CONFIG_OPTIONS.dig(option, :validations)).each do |validation|
        begin
          validation.method.call value
        rescue
          message = validation.error.call value
          raise ConfigOptionInvalid, message
        end
      end
    end
  end
end
