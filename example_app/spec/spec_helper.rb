ENV['RACK_ENV'] ||= 'test'
require 'rack/test'
require File.expand_path('../../config/environment', __FILE__)
require 'api'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
end
