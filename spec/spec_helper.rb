if ENV['COVERAGE'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require_relative '../lib/vishnu'
