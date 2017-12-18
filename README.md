# Tlapse

Automated time lapse photography using gphoto2.

## Installation

1. Install gphoto2

  * macOS: `brew install gphoto2`
  * Debian/Ubuntu: `sudo apt install gphoto2`

2. `gem install tlapse` or add `gem 'tlapse'` to your `Gemfile`.

## CLI

Find better documentation by running `tlapse help` or `tlapse help SUBCOMMAND`

* `tlapse capture` - Capture an image using the tethered camera

## API

Mostly useful for cronjobs and the like.

* Capture images between given hours
  ```ruby
  Tlapse::Capture.timelapse_command({
    from: Time.now,
    to: Time.now + 6.hours,
    interval: 30.minutes
  }) # => "gphoto2 --capture-image-and-download -I 1800 -F 12 --filename '%Y-%m-%d_%H-%M-%S.jpg'"
  ```

* Capture images from sunset to sunrise
  ```ruby
  Tlapse::Capture.timelapse_command_while_sun_is_up(interval: 30.minutes)
  # => "gphoto2 --capture-image-and-download -I 1800 -F 11 --filename '%Y-%m-%d_%H-%M-%S.jpg'"
  ```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
