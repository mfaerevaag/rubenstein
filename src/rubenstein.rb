require_relative 'IRC'
require_relative 'Settings'

class Rubenstein
  include IRC
  include Settings

  def initialize
    Settings.load!(Dir.pwd + '/config.yml')

    @server = Settings.config[:server]
    @port = Settings.config[:port]
    @channel = '#' + Settings.config[:channel]
    @nick = Settings.config[:nick]
    @real_name = Settings.config[:real_name]
    @password = Settings.config[:password]
    @hello = Settings.config[:hello]

    # Dir.foreach('./scripts') do |item|
    #   puts item
    #end

    connect
  end

  def alive?
    @socket
  end
end
