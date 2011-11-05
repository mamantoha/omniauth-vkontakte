require "omniauth-vkontakte/version"
require "omniauth"

module OmniAuth
  module Strategies
    autoload :Vkontakte,  'omniauth/strategies/vkontakte'
  end
end

OmniAuth.config.add_camelization 'vkontakte', 'Vkontakte'
