# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(__dir__)
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'simplecov'
SimpleCov.start
require 'rspec'
require 'webmock/rspec'
require 'omniauth'
require 'omniauth-vkontakte'

RSpec.configure do |config|
  config.include WebMock::API
  config.extend  OmniAuth::Test::StrategyMacros, type: :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
