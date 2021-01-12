# OmniAuth VKontakte

![Ruby](https://github.com/mamantoha/omniauth-vkontakte/workflows/Ruby/badge.svg)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/149c0614deef469faa49e1e8ae384bd3)](https://app.codacy.com/app/mamantoha/omniauth-vkontakte?utm_source=github.com&utm_medium=referral&utm_content=mamantoha/omniauth-vkontakte&utm_campaign=Badge_Grade_Dashboard)
[![Gem Version][rubygems_badge]][rubygems]
[![Maintainability](https://api.codeclimate.com/v1/badges/1ea61cb860f9f6aafb4f/maintainability)](https://codeclimate.com/github/mamantoha/omniauth-vkontakte/maintainability)

This is the unofficial [OmniAuth](https://github.com/intridea/omniauth) strategy for authenticating to VKontakte via OAuth.
To use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Vkontakte Developers Page](http://vk.com/dev).

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-vkontakte'
```

Then `bundle install`

## Usage

`OmniAuth::Strategies::Vkontakte` is simply a Rack middleware.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, ENV['VK_API_ID'], ENV['VK_API_SECRET']
end
```

[See the example Sinatra app](https://github.com/mamantoha/omniauth-vkontakte/blob/master/examples/main.rb).

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: a comma-separated list of access permissions you want to request from the user. [Read the Vkontakte docs for more details](http://vk.com/dev/permissions)
* `display`: the display context to show the authentication page. Valid options include `page`, `popup` and `mobile`.
* `lang`: specifies the language. Optional options include `ru`, `ua`, `be`, `en`, `es`, `fi`, `de`, `it`.
* `image_size`: defines the size of the user's image. Valid options include `mini`(50x50), `bigger`(100x100), `bigger_x2`(200x200), `original`(200x*) and `original_x2`(400x*). Default is `mini`.
* `info_fields`: specify which fields should be added to AuthHash when
  getting the user's info. Value should be a comma-separated string as per http://vk.com/dev/fields.
* `redirect_url`: URL where code will be passed. This URL shall be a part of the domain specified in application settings http://vk.com/dev/auth_sites.
* `https`: 1 - allows you to receive https links to photos and other media. 0 - return an http links (the default).

Here's an example of a possible configuration:

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['VKONTAKTE_KEY'], ENV['VKONTAKTE_SECRET'],
           scope: 'friends,audio,photos',
           display: 'popup',
           lang: 'en',
           https: 1,
           image_size: 'original'
end
```

## Authentication Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{"provider"=>"vkontakte",
 "uid"=>"1",
 "info"=>
  {"name"=>"Павел Дуров",
   "nickname"=>"",
   "first_name"=>"Павел",
   "last_name"=>"Дуров",
   "image"=>"http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg",
   "location"=>"Росiя, Санкт-Петербург",
   "urls"=>{"Vkontakte"=>"http://vk.com/durov"}},
 "credentials"=>
  {"token"=>
    "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
   "expires_at"=>1381826003,
   "expires"=>true},
 "extra"=>
  {"raw_info"=>
    {"id"=>1,
     "first_name"=>"Павел",
     "last_name"=>"Дуров",
     "sex"=>2,
     "nickname"=>"",
     "screen_name"=>"durov",
     "bdate"=>"10.10.1984",
     "city"=>{"id"=>2, "title"=>"Санкт-Петербург"},
     "country"=>{"id"=>1, "title"=>"Росiя"},
     "photo"=>"http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg",
     "photo_big"=>"http://cs7001.vk.me/c7003/v7003736/3a08/mEqSflTauxA.jpg",
     "online"=>1,
     "online_app"=>"3140623",
     "online_mobile"=>1}}}
```

The precise information available may depend on the permissions which you request.

## Supported Rubies

Tested with the following Ruby versions:

- Ruby MRI (2.5.0+)
- JRuby (9.2.0+)

## Contributing to omniauth-vkontakte

* Fork, fix, then send me a pull request.

## License

Copyright: 2011-2021 Anton Maminov (anton.maminov@gmail.com)

This library is distributed under the MIT license. Please see the LICENSE file.

[rubygems_badge]: http://img.shields.io/gem/v/omniauth-vkontakte.svg?style=flat
[rubygems]: http://rubygems.org/gems/omniauth-vkontakte
