require 'socket'

module IRC
  extend self

  # Connect to the IRC server
  def connect
    @socket = TCPSocket.open(@server, @port)
    send :user, @nick, '0', '*', @real_name
    send :nick, @nick
    identify @password
    send :join, @channel
    say @hello
  end

  def send(command, *args)
    str = command.to_s.upcase + ' '
    args.each do |arg|
      str += arg.to_s + ' '
    end
    str.gsub!(/PRIVMSG #{args[0]} /, "PRIVMSG #{args[0]} :")

    puts "> #{str}"
    @socket.puts str
  end

  def say_to(recipient, msg)
    send :privmsg, recipient.to_s, msg
  end

  def say(msg)
    say_to @channel, msg
  end

  def register(password)
    say_to :nickerv, "REGISTER #{password}"
  end

  def identify(password)
    say_to :nickserv, "IDENTIFY #{password}"
  end

  def listen(&block)
    until @socket.eof?
      yield @socket.gets
    end
  end
end
