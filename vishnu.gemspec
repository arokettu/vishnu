require_relative 'lib/vishnu/version'

Gem::Specification.new do |spec|
  spec.name             = 'vishnu'
  spec.version          = Vishnu::VERSION

  spec.authors          = ['Anton Smirnov', 'Kang-min Liu']
  spec.email            = 'sandfox@sandfox.me'
  spec.summary          = 'Avatar URL Generation with libravatar.org'
  spec.description      = <<DESC
Libravatar provides avatar image hosting (like gravatar.com).
Their users may associate avatar images with email or openid.
This rubygem can be used to generate Libravatar image URL
DESC
  spec.homepage         = 'https://sandfox.dev/ruby/vishnu.html'
  spec.license          = 'MIT'

  # put only lib/ into the gem
  spec.files            = `git ls-files -z`.split("\x0").grep(%r{^lib/})
  spec.require_paths    = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
