module Die

  def trigger
    /#{@irc.nick}\W? die/i
  end

  def response(str)
    args = IRC.filter(str)
    @irc.send :quit, nil, "#{@irc.quit}"
  end

  def help
    @irc.say "die - make bot quit"
  end

end
