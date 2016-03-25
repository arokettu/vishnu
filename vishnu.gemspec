require_relative 'lib/vishnu/version'

Gem::Specification.new do |spec|
  spec.name             = 'vishnu'
  spec.version          = Vishnu::VERSION

  spec.authors          = ['Anton Smirnov', 'Kang-min Liu']
  spec.email            = 'sandfox@sandfox.me'
  spec.summary          = 'Avatar URL Generation wih libravatar.org'
  spec.description      = 'libravatar.org provides avatar image hosting (like gravatar.com). Their users may associate avatar images with email or openid. This rubygem can be used to generate libravatar avatar image URL'
  spec.homepage         = 'https://github.com/sandfoxme/vishnu'
  spec.license          = 'MIT'

  spec.files            = `git ls-files -z`.split("\x0")
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',   '~> 3.4'
  spec.add_development_dependency 'simplecov'
end

