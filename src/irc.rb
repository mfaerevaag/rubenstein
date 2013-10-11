require 'socket'

module IRC

  # Connect to the IRC server
  def connect
    @socket = TCPSocket.open(@server, @port)
    @socket.puts "USER #{@nick} 0 * #{@real_name}"
    @socket.puts "NICK #{@nick}"
    identify @password
    @socket.puts "JOIN #{@channel}"
    say @hello
  end

  def say_to(recipient, msg)
    puts "> #{recipient}: #{msg}"
    @socket.puts "PRIVMSG #{recipient} :#{msg}"
  end

  def say(msg)
    say_to @channel, msg
  end

  def register(password)
    say_to "NickServ", "REGISTER #{password}"
  end

  def identify(password)
    say_to "NickServ", "IDENTIFY #{password}"
  end

  def eval(str)
    prefix = /PRIVMSG #{@channel} :#{@nick}/
    return unless str =~ prefix

    from = str.match(/^:([a-zA-Z0-9\_\-\\\[\]\{\}\^\`|]*)!/)[0][1..-2]

    str = str.split(prefix)[1]
    str.sub! /^\W*\s*/, '' # remove colon and whitespaces

    case str.strip
    when /^ping\s*$/i
      say "#{from}: pong"
    else
      # asdf
    end
  end

  def listen
    until @socket.eof?
      str = @socket.gets
      puts str
      eval(str)
    end
  end
end
