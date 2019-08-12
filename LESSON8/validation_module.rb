# frozen_string_literal: true

module ValidationModule
  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end
end
