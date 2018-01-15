unless ENV["COVERAGE"].nil?
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec/"
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "tlapse"
require "timecop"
