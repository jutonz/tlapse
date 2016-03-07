require "drb"

module Tlapse
  class Server
    attr_accessor :host, :port

    def initialize(host: "localhost", port: 9000)
      @host = host
      @port = port
    end

    def serve
      DRb.start_service full_host, drb_object
      DRb.thread.join # wait for commands
    end

    def full_host
      "druby://#{@host}:#{@port}"
    end

    private ###################################################################

    def drb_object
      obj = Object.new
      obj.extend Tlapse::Doctor
      obj.extend Tlapse::Capture
      obj
    end
  end
end
