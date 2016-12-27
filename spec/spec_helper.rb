# do not check coverage on JRuby
unless RUBY_PLATFORM == 'java'
  require 'simplecov'
  SimpleCov.start
end

require_relative '../lib/vishnu'
