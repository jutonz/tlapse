require "spec_helper"

describe Tlapse::Video do
  describe "#create_command" do
    it "adds the glob I pass in" do
      glob = "asdf-*.jpg"
      video = Tlapse::Video.new(glob: glob)

      command = video.create_command

      expect(command).to include("-i #{glob}")
    end
  end
end
