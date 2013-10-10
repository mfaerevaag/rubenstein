require 'socket'

module IRC

  # Connect to the IRC server
  def connect
    @socket = TCPSocket.open(@server, @port)
    say "USER rubenstein 0 * Rubenstein"
    say "NICK #{@nick}"
    identify "themodernprometheus"
    say "JOIN #{@channel}"
    say_to @channel, "I'M ALIVE"
  end

  # Send a message to the irc server and print it to the screen
  def say(msg)
    puts "--> #{msg}"
    @socket.puts msg
  end

  def say_to(recipient, msg)
    say "PRIVMSG #{recipient} :#{msg}"
  end

  def register(password)
    say_to "NickServ", "REGISTER #{password}"
  end

  def identify(password)
    say_to "NickServ", "IDENTIFY #{password}"
  end

  # Just keep on truckin' until we disconnect
  def listen
    until @socket.eof?
      read, write = select([@socket, $stdin], nil, nil, nil)
      next unless read

    end
  end
end
