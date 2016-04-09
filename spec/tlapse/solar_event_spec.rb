require "spec_helper"
require "byebug"

describe Tlapse::SolarEvent do
  it "initializes a SolarEventCalculator" do
    expect(Tlapse::SolarEvent.solar_event).to be_a SolarEventCalculator
  end

  it "computes sunrise" do
    expect(Tlapse::SolarEvent.sunrise).to be_a Time
  end

  it "computes sunset" do
    expect(Tlapse::SolarEvent.sunset).to be_a Time
  end
end
