require 'socket'

class IRC
  attr_accessor :keep_alive, :settings

  def initialize(settings)
    @settings = settings
    @settings[:channel].insert(0, '#')
    @keep_alive = true
  end

  # connect to the IRC server
  def connect
    @socket = TCPSocket.open(@settings[:server], @settings[:port])
    send :user, "#{@settings[:nick]} 0 * #{@settings[:real_name]}"
    send :nick, @settings[:nick]
    identify @settings[:password]
    send :join, @settings[:channel]
    say @settings[:hello]

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
    say_to @settings[:channel], msg
  end

  # register with nickserv
  def register(password)
    say_to :nickerv, "REGISTER #{settings[:password]}"
  end

  # identify with nickserv
  def identify(password)
    say_to :nickserv, "IDENTIFY #{settings[:password]}"
  end

  def quit
    send :quit, nil, "#{@settings[:quit]}"
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
      end

      yield str
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
