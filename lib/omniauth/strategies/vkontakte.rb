require 'omniauth/strategies/oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    # Authenticate to Vkontakte utilizing OAuth 2.0 and retrieve
    # basic user information.
    # documentation available here:
    # http://vkontakte.ru/developers.php?o=-17680044&p=Authorization&s=0
    #
    # @example Basic Usage
    #     use OmniAuth::Strategies::Vkontakte, 'API Key', 'Secret Key'
    class Vkontakte < OmniAuth::Strategies::OAuth2
      option :name, 'vkontakte'
      
      option :client_options, {
        :site          => 'https://api.vk.com/',
        :token_url     => '/oauth/token',
        :authorize_url => '/oauth/authorize'
      }

      option :access_token_options, {
        :param_name => 'access_token',
      }

      uid { access_token.params['user_id'] }
      
      # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      info do
        {
          :nickname   => raw_info['nickname'],
          :first_name => raw_info['first_name'],
          :last_name  => raw_info['last_name'],
          :image      => raw_info['image'],
          :urls       => {
            'Vkontakte' => "http://vk.com/#{raw_info['domain']}"
          }
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        # http://vkontakte.ru/developers.php?o=-17680044&p=Description+of+Fields+of+the+fields+Parameter
        fields = ['uid', 'first_name', 'last_name', 'nickname', 'domain', 'sex', 'bdate', 'city', 'country', 'timezone', 'photo', 'photo_big']
        access_token.get('/method/getProfiles', :params => { :uid => uid, :fields => fields.join(',') }).parsed["response"].first
      end
    end
  end
end
