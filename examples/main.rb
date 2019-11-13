# frozen_string_literal: true

require 'pp'
require 'sinatra'
require 'omniauth'
require 'omniauth-vkontakte'

configure { set :server, :puma }

SCOPE = 'friends,audio'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :vkontakte, ENV['VKONTAKTE_KEY'], ENV['VKONTAKTE_SECRET'],
           scope: SCOPE,
           display: 'popup',
           lang: 'en',
           image_size: 'original'
end

get '/' do
  <<-HTML
  <ul>
    <li><a href='/auth/vkontakte'>Sign in with VKontakte</a></li>
  </ul>
  HTML
end

get '/auth/:provider/callback' do
  content_type 'text/plain'
  pp request.env['omniauth.auth']
  request.env['omniauth.auth'].info.to_hash.inspect
end
