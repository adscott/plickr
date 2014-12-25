require 'rack/test'
require 'vcr'
require './app'

ENV['RACK_ENV'] = 'test'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: [:uri, :body] }
end

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.include RSpecMixin
end
