class Conf
  def self.value(key)
    ENV[key]
  end
end
