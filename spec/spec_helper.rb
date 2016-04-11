# do not check coverage on JRuby
if RUBY_PLATFORM != 'java'
  if ENV['CODECLIMATE_REPO_TOKEN']
    require 'codeclimate-test-reporter'
    CodeClimate::TestReporter.start
  else
    require 'simplecov'
    SimpleCov.start
  end
end

require_relative '../lib/vishnu'
