require_relative 'IRC'
require_relative 'Settings'

class Rubenstein
  include IRC
  include Settings

  def initialize
    root_dir = File.expand_path('..', File.dirname(__FILE__))

    # load settings
    Settings.load!(root_dir + '/config.yml')
    @server = Settings.config[:server]
    @port = Settings.config[:port]
    @channel = '#' + Settings.config[:channel]
    @nick = Settings.config[:nick]
    @real_name = Settings.config[:real_name]
    @password = Settings.config[:password]
    @hello = Settings.config[:hello]

    @mods = []

    # load plugins
    Dir.glob(root_dir + '/src/plugins/*.rb') do |filename|
      require filename
      mod = Object.const_get(filename.split('/')[-1].sub('.rb', '').capitalize)
      @mods << mod
    end
    puts @mods
  end

  def run
    listen do |str|
      puts str
      eval(str)
    end
  end

  # check if IRC has connected with socket
  def alive?
    @socket
  end

  private

  def eval(str)
    # check triggers
    @mods.each do |mod|
      if str =~ mod.trigger(@nick) then
        if str =~ / help$/i
          say mod.help
        else
          say mod.response(str)
        end
      end
    end
  end
end
