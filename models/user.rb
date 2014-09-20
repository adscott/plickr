require 'base64'
require './models/conf'

class User
  def initialize(name)
    @name = name
  end

  def digest
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Conf.value('SECRET'), @name)
    Base64.urlsafe_encode64(hmac).gsub(/=+$/, '')
  end

  def self.allowed(digest)
    Conf.value('USERS')
      .split(':')
      .map { |u| User.new(u).digest }
      .include?(digest)
  end
end
