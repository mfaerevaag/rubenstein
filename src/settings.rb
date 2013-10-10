require 'YAML'

class Hash
  def symbolize_keys
    self.inject({}) do |memo, (k,v)|
      memo[k.to_sym] = v
      memo
    end
  end
end

module Settings
  extend self

  @_settings = {}
  attr_reader :_settings

  def load!(filename)
    @_settings = YAML::load_file(filename).symbolize_keys
    @_settings.each_key do |key|
      @_settings[key] = @_settings[key].symbolize_keys
    end
    puts @_settings
  end

  def method_missing(name, *args, &block)
    puts "NAME #{name}"
    @_settings[name.to_sym] || fail(NoMethodError, "unknown configuration root #{name}", caller)
  end
end
