require 'socket'

class IRC
  attr_accessor :server, :port, :channel, :nick, :real_name, :password

  def initialize(params)
    @server = params[:server]
    @port = params[:port]
    @channel = '#' + params[:channel]
    @nick = params[:nick]
    @real_name = params[:real_name]
    @password = params[:password]
    @hello = params[:hello]
  end

  # Connect to the IRC server
  def connect
    @socket = TCPSocket.open(@server, @port)
    send :user, "#{@nick} 0 * #{@real_name}"
    send :nick, @nick
    identify @password
    send :join, @channel
    say @hello

    !@socket.nil?
  end

  def send(command, arg, msg=nil)
    str = command.to_s.upcase + ' '
    str += arg.to_s
    str += ' :' + msg.to_s unless msg.nil?
    #str.gsub!(/PRIVMSG #{args[0]} /, "PRIVMSG #{args[0]} :")

    puts "> #{str}"
    @socket.puts str
  end

  def say_to(recipient, msg)
    send :privmsg, recipient, msg
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
      str = @socket.gets
      if str =~ /^PING :\w+$/

        name = str.match(/^PING :(?<name>\w+)$/)[:name]
        send " :#{name}"
      else
        yield str
      end
    end
  end

  def connected?
    !@socket.nil?
  end

  def self.filter(str)
    str.match(/:(?<nick>\w+)!~?(?<user>\w+)@(?<host>.+) (?<command>\w+) (?<arg>[\w#]*) ?:(?<msg>.*)/i)
  end

end
