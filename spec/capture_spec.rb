require "spec_helper"

include Tlapse::Capture

describe Tlapse::Capture do
  describe "#captures_needed" do
    it "requires an interval" do
      expect {
        Tlapse::Capture.captures_needed
      }.to raise_error(
        ArgumentError, /missing keyword/
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

  describe ".timelapse_command" do
    let (:seven_am) { Time.current.change(hour: 7) }
    let (:seven_pm) { Time.current.change(hour: 19) }
    let (:interval) { 5.minutes }

    it "respects intervals" do
      cmd = Tlapse::Capture.timelapse_command(
        from: seven_am,
        to: seven_pm,
        interval: 10.minutes
      )

      expect(cmd).to include "-I 600"
    end

    it "applies a default filename" do
      cmd = Tlapse::Capture.timelapse_command(
        from: seven_am,
        to: seven_pm,
        interval: interval
      )

      expect(cmd).to include "--filename '%Y-%m-%d_%H-%M-%S.jpg'"
    end
  end # describe ".timelapse_command"
end
