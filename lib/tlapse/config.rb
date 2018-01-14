require "tlapse/errors"

module Tlapse
  class Config
    def self.list

    end

    def self.get(option)
      raise Tlapse::NoSuchConfigOption
    end

    def self.set(option, value)
      raise Tlapse::NoSuchConfigOption
    end
  end
end
