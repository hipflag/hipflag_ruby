# hipflag

[![Build Status](https://travis-ci.org/hipflag/hipflag_ruby.svg?branch=master)](https://travis-ci.org/hipflag/hipflag_ruby)

<img src="https://static.hipflag.com/images/logo.png" width="272" alt="Hipflag logo">

This gem is a Ruby client for interacting with [Hipflag API](https://www.hipflag.com/docs).

[Hipflag](https://www.hipflag.com) is a tool that allows to control and roll out new product features with flags. It offers a simple UI to enable/disable feature flags. It also let users to enable flags for a given percentage of users

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hipflag'
```

or install it yourself as:

    $ gem install hipflag

## Usage

### Initializing a client

The client can be configured globally:

```ruby
Hipflag.configure do |config|
  config.public_key = '**************'
  config.secret_key = '**************'
end

Hipflag::Client.new
```

or by instance:

```ruby
Hipflag::Client.new(public_key: '*******', secret_key: '*******')
```

### Client methods

Clients methods returns a `Hipflag::Response` object. This kind of objects contain methods to get the status of the request (ie: `#ok?`, `#created?`, ...) and a method called `#json` which returns a JSON representation of the response.

#### Flag
##### #flag(flag_id)

It returns relevant information about a specific flag

```ruby
client.flag('new-header').json
```

Response
```ruby
{
  'flag' => {
    'active' => true,
    'name' => 'new-header'
  }
}
```

It is possible to pass a `user_id` to check if the flag is enabled for that given user:

```ruby
client.flag('new-header', user_id: 123).json
```

If a flag is not found, the client raises a `Hipflag::Client:NotFound` exception. Example:

```ruby
client.flag('unknown-flag')
```

Exception raised:
```
Hipflag::Client::NotFound: Resource not found
```

##### #update_flag(flag_id, params)

This method updates a specific flag

```ruby
client.update_flag('new-header', rollout: 75).json
```

Response
```ruby
{
  'flag' => {
    'enabled' => true,
    'rollout' => 75,
    'name' => 'new-header'
  }
}
```

```ruby
client.update_flag('new-header', enabled: false).json
```

Response
```ruby
{
  'flag' => {
    'enabled' => false,
    'rollout' => 75,
    'name' => 'new-header'
  }
}
```

If Hipflag cannot update a flag because a param is not valid, the client raises an exception including the error message. For example:

```ruby
client.update_flag('new-header', rollout: 500).json
```

Exception raised
```
Hipflag::Client::UnprocessableEntity: {"message"=>{"rollout"=>["must be less than or equal to 100"]}}
```

You can get the list of editable attributes in the [documentation](https://www.hipflag.com/docs).

### Client errors

`Hipflag::Client` methods can raise several exceptions when performing requests:

* `Hipflag::Client::Unauthorized`: Request is not properly authenticated
* `Hipflag::Client::ServerError`: Hipflag API is not responding
* `Hipflag::Client::NotFound`: Resource is not found (`404`)
* `Hipflag::Client::UnprocessableEntity`: Request could not be processed

### How to retrieve the authentication keys

You can get your personal `Public`and `Secret` keys at https://www.hipflag.com/users/me

### How to using in Rails

The best way to use the client in a Rails application is adding a initializer: `config/initializers/hipflag.rb`:

```ruby
Hipflag.configure do |config|
  config.public_key = '**************'
  config.secret_key = '**************'
end
```

Then you can instantiate the client already containing the configuration:

```ruby
Hipflag::Client.new
=> #<Hipflag::Client:0x00007faa173be430 @public_key="**********", @secret_key="**********">
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hipflag/hipflag_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT)
