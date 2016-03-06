require "spec_helper"

include Tlapse::Capture

describe Tlapse::Capture do
  describe "#captures_needed" do
    it "requires an interval" do
      expect {
        Tlapse::Capture.captures_needed
      }.to raise_exception(
        ArgumentError, "missing keyword: interval"
      )
    end

    it "uses now as the default starting time" do
      captures = Tlapse::Capture.captures_needed(
        end_time:   Time.now,
        interval:   30.seconds
      )

      expect(captures).to eql 0
    end

    it "accepts custom starting times" do
      captures = Tlapse::Capture.captures_needed(
        start_time: 1.minute.from_now,
        end_time:   5.minutes.from_now,
        interval:   30.seconds
      )

      expect(captures).to eql 8
    end

    it "accepts duration in lieu of start and end time" do
      captures = Tlapse::Capture.captures_needed(
        duration:   30.seconds,
        interval:   30.seconds
      )

      expect(captures).to eql 1
    end

    it "prefers duration to start and end time" do
      captures = Tlapse::Capture.captures_needed(
        duration:   30.seconds,
        start_time: 1.day.ago,
        end_time:   2.days.from_now,
        interval:   30.seconds
      )

      expect(captures).to eql 1
    end

    it "calculates captures needed" do
      captures = Tlapse::Capture.captures_needed(
        end_time: 5.minutes.from_now,
        interval: 30.seconds
      )

      expect(captures).to eql 10
    end

    it "accepts arbitrary start and end times" do
      captures = Tlapse::Capture.captures_needed(
        start_time: 1.day.from_now,
        end_time:   5.days.from_now,
        interval:   1.day
      )

      expect(captures).to eql 4

    end
  end # describe "captures_needed"
end
