require "spec_helper"

describe Tlapse::SolarEvent do
  subject { Tlapse::SolarEvent }

  it "initializes a SolarEventCalculator" do
    expect(subject.solar_event).to be_a SolarEventCalculator
  end

  it "computes sunrise" do
    solar_event = SolarEventCalculator.new Date.new, 10, 10
    expect(subject).to receive(:solar_event).and_return solar_event
    expect(Tlapse::Config).to receive(:get).with("tz")
      .and_return "America/New_York"
    expect(subject.sunrise).to be_a Time
  end

  it "computes sunset" do
    solar_event = SolarEventCalculator.new Date.new, 10, 10
    expect(subject).to receive(:solar_event).and_return solar_event
    expect(Tlapse::Config).to receive(:get).with("tz")
      .and_return "America/New_York"
    expect(subject.sunset).to be_a Time
  end
end
