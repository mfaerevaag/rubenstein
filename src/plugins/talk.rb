require_relative '../irc'

module Talk

  def trigger(irc)
    /hi #{irc.nick}/i
  end
  module_function :trigger

  def response(irc, str)
    irc.say "Howdy ho!"
  end
  module_function :response

  def help(irc)
    irc.say "talk - casuall conversation"
  end
  module_function :help

end
