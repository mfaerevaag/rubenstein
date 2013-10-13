require_relative '../irc'

module Ping

  def trigger(irc)
    /#{irc.nick}\W? ping/i
  end
  module_function :trigger

  def response(irc, str)
    args = IRC.filter(str)
    irc.say "#{args[:nick]}: pong"
  end
  module_function :response

  def help(irc)
    irc.say "ping - pong"
  end
  module_function :help

end
