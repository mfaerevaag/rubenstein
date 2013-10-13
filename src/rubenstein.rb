require_relative 'IRC'
require_relative 'settings'
require_relative 'plugin'
require_relative 'utils/string'

class Rubenstein
  include Settings

  ROOT = File.expand_path('..', File.dirname(__FILE__))

  def initialize
    # load settings
    Settings.load!(ROOT + '/config.yml')
    @irc = IRC.new(Settings.config)
    @irc.connect

    @plugins = []

    # load plugins
    Dir.glob(ROOT + '/src/plugins/*.rb') do |filename|
      require filename
      mod = Object.const_get(filename.split('/')[-1].sub('.rb', '').to_camel)
      @plugins << Plugin.new(@irc).extend(mod)
    end
  end

  def run
    @irc.listen do |str|
      puts str
      eval(str)
    end
  end

  # check if IRC has connected with socket
  def alive?
    @irc.connected?
  end

  private

  # evaluate input with loaded modules
  def eval(str)
    # check triggers
    @plugins.each do |plugin|
      if str =~ plugin.trigger then
        if str =~ / help$/i
          plugin.help
        else
          plugin.response(str)
        end
      end
    end
  end
end
