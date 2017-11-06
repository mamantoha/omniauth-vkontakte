source 'https://rubygems.org'

gemspec

gem 'rack', RUBY_VERSION < '2.2.2' ? '~> 1.6' : '>= 2.0'
gem 'rake'

group :test do
  gem 'rack-test'
  gem 'rspec', '~> 3.2'
  gem 'simplecov'
  gem 'webmock'
end
