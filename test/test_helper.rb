ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'codeclimate-test-reporter'
require 'pullreview/coverage_reporter'
require 'rails/test_help'
Dir[File.dirname(__FILE__) + '/context/*.rb'].each { |file| require file }

CodeClimate::TestReporter.start
PullReview::CoverageReporter.start

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
