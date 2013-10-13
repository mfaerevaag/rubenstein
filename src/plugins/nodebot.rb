require_relative '../utils/random'

module Nodebot

  def trigger
    /.*nodebot.*/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.say "Stfu #{args[:nick]}, you dumb bitch" if Random.chance(10)
  end

  def help
    @irc.say "talk - casuall conversation"
  end

end
