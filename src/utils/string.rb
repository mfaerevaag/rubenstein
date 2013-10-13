class String

  def to_camel
    self.split(/-|_/).map(&:capitalize).join
  end

end
