require 'YAML'
require_relative 'utils/hash'

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
