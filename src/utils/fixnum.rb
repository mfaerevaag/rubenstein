class Fixnum

  def percent_chance?
    Random.rand(100) < self
  end

end
