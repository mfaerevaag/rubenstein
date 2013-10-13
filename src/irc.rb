require 'socket'

class IRC
  attr_accessor :server, :port, :channel, :nick, :real_name, :password
  attr_accessor :hello, :keep_alive

  def initialize(params)
    @server = params[:server]
    @port = params[:port]
    @channel = '#' + params[:channel]
    @nick = params[:nick]
    @real_name = params[:real_name]
    @password = params[:password]
    @hello = params[:hello]
    @keep_alive = true
  end

  # connect to the IRC server
  def connect
    @socket = TCPSocket.open(@server, @port)
    send :user, "#{@nick} 0 * #{@real_name}"
    send :nick, @nick
    identify @password
    send :join, @channel
    say @hello

    !@socket.nil?
  end

  # send command to irc through socket
  def send(command, arg, msg=nil)
    str = command.to_s.upcase + ' '
    str += arg.to_s
    str += ' :' + msg.to_s unless msg.nil?

    puts "> #{str}"
    @socket.puts str
  end

  # send privmsg
  def say_to(recipient, msg)
    send :privmsg, recipient, msg
  end

  # send privmsg to channel
  def say(msg)
    say_to @channel, msg
  end

  # register with nickserv
  def register(password)
    say_to :nickerv, "REGISTER #{password}"
  end

  # identify with nickserv
  def identify(password)
    say_to :nickserv, "IDENTIFY #{password}"
  end

  def quit
    send :quit, nil, "#{@quit}"
  end

  # listen to socket til eof
  def listen(&block)
    until @socket.eof?
      str = @socket.gets
      puts str

      if @keep_alive
        if str =~ /PING :\w+/
          name = str.match(/PING :(?<name>\w+)/)[:name]
          send :pong, nil, "#{name}"
          next
        end
      else
        yield str
      end
    end
  end

  def connected?
    !@socket.nil?
  end

  # filter line from socket
  def self.filter(str)
    str.match(/:(?<nick>\w+)!~?(?<user>\w+)@(?<host>.+) (?<command>\w+) (?<arg>[\w#]*) ?:(?<msg>.*)/i)
  end

end
