# Tlapse

Automated time lapse photography using gphoto2.

## Installation

1. Install gphoto2 and ffmpeg

  * macOS: `brew install gphoto2 ffmpeg`
  * Debian/Ubuntu: `sudo apt install gphoto2 ffmpeg`

2. `gem install tlapse`

## Example: Integrate with cron

* From 9 AM to 1 PM, capture one image every 10 minutes

```
0 9 * * * cd $HOME && tlapse alpha capture --until 1pm --interval 10
```

* From 3 PM to sunset, capture an image every minute. Compile the result into a video.

```
0 15 * * * cd $HOME && tlapse alpha capture --until sunset --interval 10 --compile
```

## CLI

Find better documentation by running `tlapse help` or `tlapse help SUBCOMMAND`

* `tlapse capture_single` - Capture an image using the tethered camera
* `tlapse until_sunset` - Generate a gphoto2 command which captures images until sunset

#### Alpha CLI

These are early-stage features which are likely to change quite a bit before they're ready for prime time.

* `tlapse alpha capture` - Capture a series of timelapse images (see `tlapse alpha capture --help` for options)

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
