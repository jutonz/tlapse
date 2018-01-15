require "solareventcalculator"
require "tlapse/config"

module Tlapse
  module SolarEvent
    def self.sunrise
      tz = Tlapse::Config.get "tz"
      s  = solar_event.compute_official_sunrise(tz)
      n  = Time.new
      Time.new(n.year, n.month, n.day, s.hour, s.minute)
    end

    def self.sunset
      tz = Tlapse::Config.get "tz"
      s  = solar_event.compute_official_sunset(tz)
      n  = Time.new
      Time.new(n.year, n.month, n.day, s.hour, s.minute)
    end

    def self.solar_event
      date = Date.new
      lat, lon = Tlapse::Config.get "lat", "lon"
      SolarEventCalculator.new date, lat, lon
    end
  end
end
