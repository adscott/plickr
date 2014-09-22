require 'base64'
require './models/conf'

class User

  attr_accessor :name

  def initialize(name,secret=nil)
    @name = name
    @secret ||= Conf.value('SECRET')
  end

  def digest
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @secret, @name)
    Base64.urlsafe_encode64(hmac).gsub(/=+$/, '')
  end

  def self.allowed(digest)
    all.map(&:digest).include?(digest)
  end

  def self.all
    Conf.value('USERS')
      .split(':')
      .map { |u| User.new(u) }
  end
end
