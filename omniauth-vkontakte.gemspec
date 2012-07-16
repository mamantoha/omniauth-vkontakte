# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-vkontakte/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth', '~> 1.1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.0'
  gem.add_dependency 'multi_json'

  gem.authors       = ["Anton Maminov"]
  gem.email         = ["anton.linux@gmail.com"]
  gem.description   = %q{Unofficial VKontakte strategy for OmniAuth 1.0}
  gem.summary       = %q{Unofficial VKontakte strategy for OmniAuth 1.0}
  gem.homepage      = "https://github.com/mamantoha/omniauth-vkontakte"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-vkontakte"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Vkontakte::VERSION
end
