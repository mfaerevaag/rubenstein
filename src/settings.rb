require 'YAML'

class Hash
  def symbolize_keys
    self.inject({}) do |hash, (key, value)|
      hash[key.to_sym] = value
      hash
    end
  end
end

module Settings
  extend self

  @_settings = {}
  attr_reader :_settings

  def load!(filename)
    @_settings = YAML::load_file(filename).symbolize_keys
    @_settings.each { |key, value| @_settings[key] = value.symbolize_keys }
  end

  def method_missing(sym, *args, &block)
    @_settings[sym] || super
  end
end
