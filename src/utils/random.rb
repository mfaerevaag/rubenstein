class Random

  def self.chance(percent)
    Random.rand(100) < percent % 100
  end

end
