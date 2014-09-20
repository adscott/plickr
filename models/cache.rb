require 'dalli'
require './models/conf'

class Cache
  def initialize
    if Conf.value('MEMCACHIER_SERVERS').nil?
      @delegate = Dalli::Client.new
    else
      servers = Conf.value('MEMCACHIER_SERVERS').split(',')
      creds = {:username => Conf.value('MEMCACHIER_USERNAME'), :password => Conf.value('MEMCACHIER_PASSWORD')}
      @delegate = Dalli::Client.new(servers, creds)
    end
  end

  def delegate
    @delegate
  end

  def fetch(key, ttl=nil, &block)
    begin
      @delegate.fetch(key, ttl, &block)
    rescue Dalli::RingError
      yield
    end
  end

  def stats
    @delegate.stats
  end

  def flush
    @delegate.flush
  end

  def self.instance
    @@instance ||= Cache.new
  end
end
