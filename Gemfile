source 'https://rubygems.org'

gemspec

gem 'rake'
gem 'rack', RUBY_VERSION < '2.2.2' ? '~> 1.6' : '>= 2.0'

group :test do
  gem 'rspec', '~> 3.2'
  gem 'rack-test'
  gem 'simplecov'
  gem 'webmock'
end
