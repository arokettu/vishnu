# Vishnu

[![Gem Version](https://badge.fury.io/rb/vishnu.svg)](http://badge.fury.io/rb/vishnu)
[![Reference Status](https://www.versioneye.com/ruby/vishnu/reference_badge.svg)](https://www.versioneye.com/ruby/vishnu/references)
[![Build Status](https://travis-ci.org/sandfoxme/vishnu.svg?branch=master)](https://travis-ci.org/sandfoxme/vishnu)

Vishnu is a simple library to use Libravatar avatars in your ruby app. 

[Libravatar](https://libravatar.org/) is an avatar service to let their 
users associate avatar images with their emails or openids. This rubygem 
generates their avatar URL.

## Installation

Add the following line to your ```Gemfile```:
    
```ruby
gem 'vishnu'
```

Or if you want to register ```Libravatar``` alias, then:

```ruby
gem 'vishnu', require: 'libravatar'
```

## Usage

```ruby
Vishnu.new(email:  'someone@example.com').url   # get avatar for email
Vishnu.new(openid: 'https://example.com').url   # get avatar for OpenID URL
Vishnu.new(email:  'someone@example.com').to_s  # use to_s alias

# use all options
avatar = Vishnu.new(
    email:      'someone@example.com',  # email
    openid:     'https://example.com/', # OpenID URL. If both email and url are set,
                                        # you will get avatar for the email
    size:       150,                    # avatar size, 1-512; default is 80
    default:    'identicon',            # '404', 'mm', 'identicon', 'monsterid', 'wavatar', 'retro'
                                        # or url to your default
    https:      true,                   # use secure url or not; default is false
)

avatar.size = 40    # all params are also available as attributes

avatar.url          # get avatar url new style
avatar.to_s         # and old style
# => "https://seccdn.libravatar.org/avatar/16d113840f999444259f73bac9ab8b10?s=40&d=identicon"

require 'libravatar' # register an alias if you didn't add require: 'libravatar' to your Gemfile
Libravatar.new(email: 'someone@example.com').to_s   # libravatar gem style 
```

## libravatar gem compatibility

As a fork, vishnu is mostly compatible to the [libravatar](https://rubygems.org/gems/libravatar) v1.2.0 gem.

Major differences in 2.0 are:
 
*   ruby < 2.0.0 is no longer supported
*   methods ```get_target_domain```, ```srv_lookup```, ```get_base_url```
(basically everything except `to_s` and attribute setters / getters) 
are now private
    
If you for some reason depend on these features, use ```vishnu 1.2.1``` 
which is basically rebranded bugfix for ```libravatar 1.2.0```.

## License

Licensed under the MIT License. See ```LICENSE.txt``` for further details.
