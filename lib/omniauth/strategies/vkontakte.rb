require 'omniauth/strategies/oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    # Authenticate to Vkontakte utilizing OAuth 2.0 and retrieve
    # basic user information.
    # documentation available here:
    # http://vk.com/dev/authentication
    #
    # @example Basic Usage
    #     use OmniAuth::Strategies::Vkontakte, 'API Key', 'Secret Key'
    class Vkontakte < OmniAuth::Strategies::OAuth2
      API_VERSION = '5.2'
      DEFAULT_SCOPE = ''

      option :name, 'vkontakte'

      option :client_options, {
        :site          => 'https://api.vk.com/',
        :token_url     => 'https://oauth.vk.com/access_token',
        :authorize_url => 'https://oauth.vk.com/authorize',
      }

      option :authorize_options, [:scope, :display]

      uid { access_token.params['user_id'].to_s }

      # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      info do
        {
          :name       => [raw_info['first_name'], raw_info['last_name']].map(&:strip).reject(&:empty?).join(' '),
          :nickname   => raw_info['nickname'],
          :first_name => raw_info['first_name'],
          :last_name  => raw_info['last_name'],
          :image      => raw_info['photo'],
          :location   => location,
          :urls       => {
            'Vkontakte' => "http://vk.com/#{raw_info['screen_name']}"
          },
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= begin
          params = {
            :user_ids => uid,
            :fields   => info_options,
            :lang     => lang_option,
            :v        => API_VERSION,
            #:access_token => access_token.token,
          }

          result = access_token.get('/method/users.get', :params => params).parsed["response"]
          (result && result.first) ? result.first : nil
        end
      end

      def info_options
        # http://vk.com/dev/fields
        fields = ['nickname', 'screen_name', 'sex', 'city', 'country', 'online', 'bdate', 'photo', 'photo_big']
        return fields.join(',')
      end

      def lang_option
        options[:lang] || ''
      end

      # You can pass +display+ or +scope+ params to the auth request, if
      # you need to set them dynamically.
      #
      # http://vk.com/dev/oauth_dialog
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

      # http://vk.com/dev/database.getCountriesById
      def get_country
        if raw_info['country'] && raw_info['country'] != "0"
          params = {
            :country_ids => raw_info['country'],
            :lang        => lang_option,
            :v           => API_VERSION,
          }
          country = access_token.get('/method/database.getCountriesById', :params => params).parsed['response']
          country && country.first ? country.first['title'] : ''
        else
          ''
        end
      end

      # http://vk.com/dev/database.getCitiesById
      def get_city
        if raw_info['city'] && raw_info['city'] != "0"
          params = {
            :city_ids => raw_info['city'],
            :lang     => lang_option,
            :v        => API_VERSION,
          }
          city = access_token.get('/method/database.getCitiesById', :params => params).parsed['response']
          city && city.first ? city.first['title'] : ''
        else
          ''
        end
      end

      def location
        @location ||= [get_country, get_city].map(&:strip).reject(&:empty?).join(', ')
      end

    end
  end
end
