module Greet

  def trigger
    /^:(?!rubenstein).* JOIN/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.say "Good day, #{args[:nick]}"
  end

  def help
    @irc.say "talk - casuall conversation"
  end

end
