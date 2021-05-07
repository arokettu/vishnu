# Vishnu

[![Gem](https://img.shields.io/gem/v/vishnu.svg?style=flat-square)](https://rubygems.org/gems/commonmarker-rouge)
[![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/sandfox/vishnu/master.svg?style=flat-square)](https://gitlab.com/sandfox/vishnu/-/pipelines)

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

## Simple Usage

```ruby
Vishnu.new(email:  'someone@example.com').url   # get avatar for email
Vishnu.new(openid: 'https://example.com').url   # get avatar for OpenID URL
```

## Documentation

Read full documentation here: <https://sandfox.dev/ruby/vishnu.html>

## Support

Please file issues on our main repo at GitLab: <https://gitlab.com/sandfox/vishnu/-/issues>

## License

Licensed under the MIT License. See ```LICENSE.txt``` for further details.
