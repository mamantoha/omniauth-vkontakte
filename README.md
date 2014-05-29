# OmniAuth VKontakte

This is the unofficial [OmniAuth](https://github.com/intridea/omniauth) strategy for authenticating to VKontakte via OAuth.
To use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Vkontakte Developers Page](http://vk.com/dev).

## Basic Usage

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
end
```

## Configuring
You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: a comma-separated list of access permissions you want to request from the user. [Read the Vkontakte docs for more details](http://vk.com/dev/permissions)
* `display`: the display context to show the authentication page. Valid options include `page`, `popup` and `mobile`.
* `lang`: specifies the language. Optional options include `ru`, `ua`, `be`, `en`, `es`, `fi`, `de`, `it`.
* `image_size`: defines the size of the user's image. Valid options include `mini`(50x50), `bigger`(100x100) and `original`(200x200). Default is `mini`.
* `info_fields`: specify which fields should be added to AuthHash when
  getting the user's info. Value should be a comma-separated string as per http://vk.com/dev/fields.

Here's an example of a possible configuration:

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET'],
    {
      :scope => 'friends,audio,photos',
      :display => 'popup',
      :lang => 'en',
      :image_size => 'original'
    }
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
     "city"=>"2",
     "country"=>"1",
     "photo"=>"http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg",
     "photo_big"=>"http://cs7001.vk.me/c7003/v7003736/3a08/mEqSflTauxA.jpg",
     "online"=>1,
     "online_app"=>"3140623",
     "online_mobile"=>1}}}
```

The precise information available may depend on the permissions which you request.


## Supported Rubies

Tested with the following Ruby versions:

- MRI 2.0.0
- MRI 1.9.3

## Contributing to omniauth-vkontakte

* Fork, fix, then send me a pull request.

## License

Copyright (c) 2011-2013 Anton Maminov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
