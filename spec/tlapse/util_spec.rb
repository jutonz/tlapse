require "spec_helper"

describe Tlapse::Util do
  describe ".normalized_filename" do
    it "uses the default format" do
      file = double :file

      Timecop.freeze do
        expect(File).to receive(:mtime).with(file).and_return Time.now

        expected = Time.now.strftime(Tlapse::Capture::CAPTURE_FILENAME)
        expect(Tlapse::Util.normalized_filename(file)).to eql expected
      end
    end
  end
end
