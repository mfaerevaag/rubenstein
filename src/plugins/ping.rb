require_relative '../irc'

module Ping
  extend IRC

  def trigger(nick)
    /#{nick}\W* ping/i
  end
  module_function :trigger

  def response(str)
    args = filter(str)
    "#{args[:nick]}: pong"
  end
  module_function :response

  def help
    "ping - pong"
  end
  module_function :help

end
