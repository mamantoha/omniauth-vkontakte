# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    # Authenticate to Vkontakte utilizing OAuth 2.0 and retrieve
    # basic user information.
    # documentation available here:
    # http://vk.com/dev/authentication
    #
    # @example Basic Usage
    #     use OmniAuth::Strategies::Vkontakte, 'API Key', 'Secret Key'
    #
    class Vkontakte < OmniAuth::Strategies::OAuth2
      class NoRawData < StandardError; end

      API_VERSION = '5.107'

      DEFAULT_SCOPE = ''

      option :name, 'vkontakte'

      option :client_options,
             site: 'https://api.vk.com/',
             token_url: 'https://oauth.vk.com/access_token',
             authorize_url: 'https://oauth.vk.com/authorize'

      option :authorize_options, %i[scope display]

      option :redirect_url, nil

      uid { raw_info['id'].to_s }

      # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      info do
        {
          name: "#{raw_info['first_name']} #{raw_info['last_name']}".strip,
          nickname: raw_info['nickname'],
          email: access_token.params['email'],
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          image: image_url,
          location: location,
          urls: {
            'Vkontakte' => "http://vk.com/#{raw_info['screen_name']}"
          }
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = :access_token
        @raw_info ||= begin
          result = access_token.get('/method/users.get', params: params).parsed['response']

          raise NoRawData, result unless result.is_a?(Array) && result.first

          result.first
        end
      end

      # You can pass +display+, +revoke+ or +scope+ params to the auth request,
      # if you need to set them dynamically.
      #
      # http://vk.com/dev/oauth_dialog
      #
      # +revoke+ revokes access and re-authorizes user.
      def authorize_params
        super.tap do |params|
          # just a copypaste from ominauth-facebook
          %w[display state scope revoke].each do |v|
            next unless request.params[v]

            params[v.to_sym] = request.params[v]

            # to support omniauth-oauth2's auto csrf protection
            session['omniauth.state'] = params[:state] if v == 'state'
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      def params
        {
          fields: info_options,
          lang: lang_option,
          https: https_option,
          v: API_VERSION
        }
      end

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end

      def info_options
        # http://vk.com/dev/fields
        fields = %w[
          nickname screen_name sex city country online bdate
          photo_50 photo_100 photo_200 photo_200_orig photo_400_orig
        ]
        fields.concat(options[:info_fields].split(',')) if options[:info_fields]
        fields.join(',')
      end

      def lang_option
        options[:lang] || ''
      end

      def https_option
        options[:https] || 0
      end

      def image_url
        case options[:image_size]
        when 'mini'
          raw_info['photo_50']
        when 'bigger'
          raw_info['photo_100']
        when 'bigger_x2'
          raw_info['photo_200']
        when 'original'
          raw_info['photo_200_orig']
        when 'original_x2'
          raw_info['photo_400_orig']
        else
          raw_info['photo_50']
        end
      end

      def location
        country = raw_info.fetch('country', {})['title']
        city = raw_info.fetch('city', {})['title']
        @location ||= [country, city].compact.join(', ')
      end

      def callback_phase
        super
      rescue NoRawData => e
        fail!(:no_raw_data, e)
      end
    end
  end
end
