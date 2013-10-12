require_relative '../irc'

module Talk
  extend IRC

  def trigger(nick)
    /hi #{nick}/i
  end
  module_function :trigger

  def response(str)
    #args = filter(str)
    "Howdy ho!"
  end
  module_function :response

  def help
    "talk - casuall conversation"
  end
  module_function :help

end
