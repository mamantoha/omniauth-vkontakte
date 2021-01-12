# frozen_string_literal: true

require File.expand_path('lib/omniauth/vkontakte/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Anton Maminov']
  gem.email         = ['anton.maminov@gmail.com']
  gem.summary       = 'Vkontakte OAuth2 Strategy for OmniAuth'
  gem.homepage      = 'https://github.com/mamantoha/omniauth-vkontakte'
  gem.licenses      = ['MIT']

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-vkontakte'
  gem.require_paths = ['lib']
  gem.version       = OmniAuth::Vkontakte::VERSION
  gem.required_ruby_version = '>= 2.5.0'
  gem.add_runtime_dependency 'omniauth-oauth2', ['>= 1.5', '<= 1.7.1']
end
