require "spec_helper"
require "tempfile"
require "yaml"

describe Tlapse::Config do
  subject { Tlapse::Config }

  describe ".cast" do
    it "handles float" do
      option = "pi"
      value = "3.14"
      expect(Tlapse::Config).to receive(:type_for).with(option)
        .and_return(:float)
      expect(Tlapse::Config.cast(option, value)).to eql value.to_f
    end

    it "handles string" do
      option = "pi"
      value = "3.14"
      expect(Tlapse::Config).to receive(:type_for).with(option)
        .and_return(:string)
      expect(Tlapse::Config.cast(option, value)).to eql value.to_s
    end

    it "handles integer" do
      option = "pi"
      value = "3.14"
      expect(Tlapse::Config).to receive(:type_for).with(option)
        .and_return(:integer)
      expect(Tlapse::Config.cast(option, value)).to eql value.to_i
    end

    it "does nothing by default" do
      option = "pi"
      value = "3.14"
      expect(Tlapse::Config).to receive(:type_for).with(option)
        .and_return(nil)
      expect(Tlapse::Config.cast(option, value)).to eql value
    end
  end

  describe ".type_for" do
    it "returns the type" do
      option = "option"
      type = :fizzle
      config_options = { option => { type: type } }
      stub_const("Tlapse::Config::CONFIG_OPTIONS", config_options)

      expect(Tlapse::Config.type_for(option)).to eql type
    end

    it "returns nil if no type" do
      option = "option"
      type = :fizzle
      config_options = {}
      stub_const("Tlapse::Config::CONFIG_OPTIONS", config_options)

      expect(Tlapse::Config.type_for(option)).to eql nil
    end
  end

  describe ".user_values" do
    it "returns empty if the config file is not present" do
      stub_const "Tlapse::Config::CONFIG_PATH", "/tmp/blah-#{Time.now.to_i}"
      expect(subject.user_values).to be_empty
    end

    it "reads the config file" do
      key = "hey"
      value = "yo"
      config = { key => value }
      Tempfile.create do |f|
        stub_const "Tlapse::Config::CONFIG_PATH", f.path
        f.write config.to_yaml
        f.flush

        expect(subject.user_values).to eql config
      end
    end
  end

  describe ".value_for" do
    it "returns the casted value" do
      option = "option"
      value = "value"
      user_values = { option => value }
      config_options = {
        option => {
          type: :string
        }
      }

      expect(subject).to receive(:user_values).and_return user_values
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options

      expect(subject.value_for(option)).to eql value.to_s
    end

    it "returns CONFIG_UNDEFINED if value is not in config file" do
      user_values = {}
      expect(subject).to receive(:user_values).and_return user_values

      expect(subject.value_for(:blah)).to eql subject::CONFIG_UNDEFINED
    end
  end

  describe ".default_for" do
    it "returns the casted default option" do
      option = "woah"
      default = "dang"
      config_options = {
        option => { default: default, type: :string }
      }
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options

      expect(subject.default_for(option)).to eql default.to_s
    end

    it "evaluates lazily defined defaults" do
      option = "woah"
      default = "dang"
      lazy_default = -> { default }
      config_options = {
        option => { default: lazy_default, type: :string }
      }
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options

      expect(subject.default_for(option)).to eql default.to_s
    end
  end

  describe ".verify_option_exists!" do
    it "raises unless the option exists" do
      stub_const "Tlapse::Config::CONFIG_OPTIONS", {}
      expect { subject.verify_option_exists!(:anything) }
        .to raise_exception(Tlapse::NoSuchConfigOption)
    end
  end

  describe ".save" do
    it "creates the nested directory structure and writes the file" do
      user_values = {}
      dirname = "/tmp/wee/wow"
      filename = "tlapse.conf"
      config_path = File.join dirname, filename
      stub_const "Tlapse::Config::CONFIG_PATH", config_path

      expect(FileUtils).to receive(:mkdir_p).with(dirname)
      expect(File).to receive(:write).with(config_path, user_values.to_yaml)

      subject.save(user_values)
    end
  end

  describe ".validate!" do
    it "runs validations and returns errors" do
      option = "option"
      value = "value"
      error_message = "nope"
      validation = Tlapse::Config::Validation.new(
        ->(value) { raise },
        ->(value) { error_message }
      )
      config_options = {
        option => { validations: [validation] }
      }
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options

      expect { subject.validate!(option, value) }
        .to raise_error(Tlapse::ConfigOptionInvalid, error_message)
    end
  end

  describe ".unset" do
    it "calls set with the default" do
      option = "option"
      value = "value"
      default = "default"

      expect(subject).to receive(:default_for).with(option).and_return(default)
      expect(subject).to receive(:set).with(option, default)

      subject.unset(option)
    end
  end

  describe ".get" do
    it "returns the casted value if present" do
      option = "option"
      value = "value"

      expect(subject).to receive(:verify_option_exists!).with(option)
      expect(subject).to receive(:value_for).with(option).and_return(value)

      expect(subject.get(option)).to eql value
    end

    it "returns the default if no value is present" do
      option = "option"
      value = subject::CONFIG_UNDEFINED
      default = "default"

      expect(subject).to receive(:verify_option_exists!).with(option)
      expect(subject).to receive(:value_for).with(option).and_return(value)
      expect(subject).to receive(:default_for).with(option).and_return(default)

      expect(subject.get(option)).to eql default
    end

    it "can handle multiple options" do
      option1 = "option1"
      default1 = "default1"
      option2 = "option2"
      default2 = "default2"
      config_options = {
        option1 => { default: default1 },
        option2 => { default: default2 }
      }
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options
      stub_const "Tlapse::Config::CONFIG_KEYS", config_options.keys

      expect(subject.get(option1, option2)).to eql [default1, default2]
    end
  end

  describe ".set" do
    it "sets the option to the value" do
      option = "option"
      value = "value"
      user_values = {}

      expect(subject).to receive(:verify_option_exists!).with(option)
      expect(subject).to receive(:user_values).and_return(user_values)
      expect(subject).to receive(:save).with user_values.merge({ option => value })

      subject.set option, value
    end

    it "complains if the value is invalid" do
      option = "option"
      value = "value"
      config_options = {
        option => {
          validations: [
            subject::Validation.new(
              ->(value) { raise },
              ->(value) { "incorrect" }
            )
          ]
        }
      }
      stub_const "Tlapse::Config::CONFIG_OPTIONS", config_options
      expect(subject).to receive(:verify_option_exists!).with(option)

      expect { subject.set(option, value) }
        .to raise_error(Tlapse::ConfigOptionInvalid)
    end

    it "does not write default values" do
      option = "option"
      value = "value"
      default = "default"
      user_values = { option => "some other value" }

      expect(subject).to receive(:verify_option_exists!).with(option)
      expect(subject).to receive(:default_for).with(option).and_return(default)
      expect(subject).to receive(:user_values).and_return(user_values)
      expect(subject).to receive(:save).with({})

      subject.set option, default
    end
  end
end
