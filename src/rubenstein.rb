require_relative 'IRC'

class Rubenstein
  include IRC

  def initialize(server, port, nick, channel)
    @server = server
    @port = port
    @nick = nick
    @channel = channel

    # Dir.foreach('./scripts') do |item|
    #   puts item
    #end

    connect
  end

  def alive?
    @socket
  end
end
