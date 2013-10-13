class Hash

  def symbolize_keys
    self.inject({}) do |hash, (key, value)|
      hash[key.to_sym] = value
      hash
    end
  end

end
