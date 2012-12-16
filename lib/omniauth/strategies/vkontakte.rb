require 'omniauth/strategies/oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    # Authenticate to Vkontakte utilizing OAuth 2.0 and retrieve
    # basic user information.
    # documentation available here:
    # http://vk.com/developers.php?o=-17680044&p=Authorization&s=0
    #
    # @example Basic Usage
    #     use OmniAuth::Strategies::Vkontakte, 'API Key', 'Secret Key'
    class Vkontakte < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'notify'

      option :name, 'vkontakte'

      option :client_options, {
        :site          => 'https://api.vk.com/',
        :token_url     => '/oauth/token',
        :authorize_url => '/oauth/authorize'
      }

      option :access_token_options, {
        :param_name => 'access_token'
      }

      option :authorize_options, [:scope, :display]

      option :provider_ignores_state, true

      uid { access_token.params['user_id'].to_s }

      # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      info do
        {
          :name       => [raw_info['first_name'], raw_info['last_name']].map(&:strip).reject(&:blank?).join(' '),
          :nickname   => raw_info['nickname'],
          :first_name => raw_info['first_name'],
          :last_name  => raw_info['last_name'],
          :image      => raw_info['photo'],
          :location   => location,
          :urls       => {
            'Vkontakte' => "http://vk.com/#{raw_info['screen_name']}"
          }
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        # http://vk.com/developers.php?o=-17680044&p=Description+of+Fields+of+the+fields+Parameter
        fields = ['uid', 'first_name', 'last_name', 'nickname', 'screen_name', 'sex', 'city', 'country', 'online', 'bdate', 'photo', 'photo_big']

        @raw_info ||= begin
          params = {
            :uids         => uid,
            :fields       => fields.join(','),
            #:access_token => access_token.token,
          }
          result = access_token.get('/method/users.get', :params => params).parsed["response"]
          result && result.first ? result.first : nil
        end
      end

      ##
      # You can pass +display+ or +scope+ params to the auth request, if
      # you need to set them dynamically.
      #
      # /auth/vkontakte?display=popup
      #
      def authorize_params
        super.tap do |params|
          # just a copypaste from ominauth-facebook
          %w[display state scope].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
              # to support omniauth-oauth2's auto csrf protection
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      # http://vk.com/developers.php?o=-17680044&p=getCountries
      def get_country
        if raw_info['country'] && raw_info['country'] != "0"
          params = {
            :cids         => raw_info['country'],
            :access_token => access_token.token,
          }
          country = access_token.get('/method/places.getCountryById', :params => params).parsed['response']
          country && country.first ? country.first['name'] : ''
        else
          ''
        end
      end

      # http://vk.com/developers.php?o=-17680044&p=getCities
      def get_city
        if raw_info['city'] && raw_info['city'] != "0"
          params = {
            :cids         => raw_info['city'],
            :access_token => access_token.token,
          }
          city = access_token.get('/method/places.getCityById', :params => params).parsed['response']
          city && city.first ? city.first['name'] : ''
        else
          ''
        end
      end

      def location
        @location ||= [get_country, get_city].map(&:strip).reject(&:blank?).join(', ')
      end

    end
  end
end
