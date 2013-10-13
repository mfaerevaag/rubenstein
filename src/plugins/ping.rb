module Ping

  def trigger
    /#{@irc.nick}\W? ping/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.say "#{args[:nick]}: pong"
  end

  def help
    @irc.say "ping - pong"
  end

end
