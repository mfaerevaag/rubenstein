require_relative '../utils/fixnum'

module Nodebot

  def trigger
    /.*nodebot.*/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.say "Stfu #{args[:nick]}, you dumb bitch" if 10.percent_chance?
  end

  def help
    @irc.say "talk - casuall conversation"
  end

end
