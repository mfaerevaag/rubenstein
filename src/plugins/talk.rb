module Talk

  def trigger
    /hi #{@irc.nick}/i
  end

  def response(str)
    @irc.say "Howdy ho!"
  end

  def help
    @irc.say "talk - casuall conversation"
  end

end
