require File.expand_path('lib/omniauth-vkontakte/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Anton Maminov']
  gem.email         = ['anton.linux@gmail.com']
  gem.description   = 'Unofficial VKontakte strategy for OmniAuth 1.0'
  gem.summary       = 'Unofficial VKontakte strategy for OmniAuth 1.0'
  gem.homepage      = 'https://github.com/mamantoha/omniauth-vkontakte'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-vkontakte'
  gem.require_paths = ['lib']
  gem.version       = OmniAuth::Vkontakte::VERSION

  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.2'
end
