# OmniAuth VKontakte

This is the unofficial [OmniAuth](https://github.com/intridea/omniauth) strategy for authenticating to VKontakte via OAuth.
To use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Vkontakte Developers Page](http://vk.com/developers.php).

## Basic Usage

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
end
```

## Configuring
You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A comma-separated list of permissions you want to request from the user. [Read the Vkontakte docs for more details](http://vk.com/developers.php?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9)
* `display`: The display context to show the authentication page. Options are: `page`, `popup`, `touch` and `wap`.

For example, to request `friends`, `audio` and `photos` permissions and display the authentication page in a popup window:

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET'],
    :scope => 'friends,audio,photos', :display => 'popup'
end
```

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :credentials => {
    :expires => true,
    :expires_at => 1361547867,
    :token => "ABCD..."
  }, 
  :extra => {
    :raw_info => {
      :bdate => "1.2.1981",
      :city => "1",
      :country => "1",
      :first_name => "Maksim",
      :last_name => "Berjoza",
      :nickname => "",
      :online => 0,
      :photo => "http://cs416330.userapi.com/v416330678/316f/ues1IwqID-I.jpg",
      :photo_big => "http://cs416330.userapi.com/v416330678/316c/pFvgPJpenjo.jpg",
      :screen_name => "id677678",
      :sex => 2,
      :uid => 677678
    }
  },
  :info => {
    :first_name => "Maksim",
    :image => "http://cs416330.userapi.com/v416330678/316f/ues1IwqID-I.jpg",
    :last_name => "Berjoza",
    :location => "Россия, Москва",
    :name => "Maksim Berjoza", 
    :nickname => "",
    :urls => {
      :Vkontakte => "http://vk.com/id677678"
    }
  },
  :provider => "vkontakte",
  :uid => 677678
}
```

The precise information available may depend on the permissions which you request.


## Supported Rubies

Tested with the following Ruby versions:

- MRI 1.9.3
- MRI 1.8.7

## Contributing to omniauth-vkontakte

* Fork, fix, then send me a pull request.

## License

Copyright (c) 2011-2013 Anton Maminov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
