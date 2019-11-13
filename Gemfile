# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'rack', RUBY_VERSION < '2.2.2' ? '~> 1.6' : '>= 2.0'
gem 'rake'

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov'
  gem 'webmock'
end
