# frozen_string_literal: true

require 'omniauth/vkontakte/version'
require 'omniauth'

# :nodoc:
module OmniAuth
  # :nodoc:
  module Strategies
    autoload :Vkontakte, 'omniauth/strategies/vkontakte'
  end
end

OmniAuth.config.add_camelization 'vkontakte', 'Vkontakte'
