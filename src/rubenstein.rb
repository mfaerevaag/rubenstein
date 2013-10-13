
require_relative 'IRC'
require_relative 'settings'
require_relative 'utils/string'

class Rubenstein
  include Settings

  ROOT = File.expand_path('..', File.dirname(__FILE__))

  def initialize
    # load settings
    Settings.load!(ROOT + '/config.yml')
    @irc = IRC.new(Settings.config)
    @irc.connect

    @mods = []

    # load plugins
    Dir.glob(ROOT + '/src/plugins/*.rb') do |filename|
      require filename
      mod = Object.const_get(filename.split('/')[-1].sub('.rb', '').to_camel)
      @mods << mod
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
    @mods.each do |mod|
      if str =~ mod.trigger(@irc) then
        if str =~ / help$/i
          mod.help(@irc)
        else
          mod.response(@irc, str)
        end
      end
    end
  end
end
