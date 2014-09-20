require 'sinatra'
require 'base64'

get '/' do
  'Hello World!'
end

get '/:digest/' do
  valid = ENV['USERS']
    .split(':')
    .map { |user| OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['SECRET'], user) }
    .map { |hmac| Base64.urlsafe_encode64(hmac) }
    .map { |encoded| encoded.gsub(/=+$/, '') }
    .include?(params[:digest])

  pass unless valid

  'Photos!'
end
