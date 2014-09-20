require 'sinatra'

get '/' do
  'Hello World!'
end

get '/:digest/' do
  valid = ENV['users']
    .split(':')
    .map { |user| OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['secret'], user) }
    .include?(params[:digest])

  pass unless valid

  'Photos!'
end
