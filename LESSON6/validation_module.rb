module ValidationModule

  def valid?
    validate!
    true
  rescue
    false
  end
end
