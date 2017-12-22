require "rainbow"

module Tlapse
  class Logger
    ERROR_COLOR = :red

    def self.error(message)
      puts Rainbow(message).fg ERROR_COLOR
    end

    ##
    # Print the error message and then exit
    def self.error!(message, exit_code: 1)
      error message
      exit exit_code
    end
  end
end
