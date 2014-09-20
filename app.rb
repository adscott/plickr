require 'sinatra'
require './user'

get '/' do
  'Hello World!'
end

get '/:digest/' do
  valid = ENV['USERS']
    .split(':')
    .map { |u| User.new(u) }
    .map { |u| u.digest(ENV['SECRET']) }
    .include?(params[:digest])

  pass unless valid

  'Photos!'
end
