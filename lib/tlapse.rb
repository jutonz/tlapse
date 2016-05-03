require "sidekiq"

require_relative "tlapse/version"
require_relative "tlapse/doctor"
require_relative "tlapse/capture"
require_relative "tlapse/video"
require_relative "tlapse/server"
require_relative "tlapse/solar_event"
require_relative "tlapse/automatic"
require_relative "workers/scheduled_capture"

include Tlapse::Doctor
include Tlapse::Capture

module Tlapse

end
