require 'base64'

class User
  def initialize(name)
    @name = name
  end

  def digest(key)
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, @name)
    Base64.urlsafe_encode64(hmac).gsub(/=+$/, '')
  end
end
