require "solareventcalculator"

module Tlapse
  module SolarEvent
    LAT  = 35.779590
    LON  = -78.638179
    TZ   = "America/New_York"

    def self.sunrise
      s = solar_event.compute_official_sunrise(TZ)
      n = Time.new
      Time.new(n.year, n.month, n.day, s.hour, s.minute)
    end

    def self.sunset
      s = solar_event.compute_official_sunset(TZ)
      n = Time.new
      Time.new(n.year, n.month, n.day, s.hour, s.minute)
    end

    def self.solar_event
      date = Date.new
      SolarEventCalculator.new date, LAT, LON
    end
  end
end
