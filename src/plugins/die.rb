module Die

  def trigger
    /#{@irc.settings[:nick]}\W? die/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.quit
  end

  def help
    @irc.say "die - make bot quit"
  end

end
