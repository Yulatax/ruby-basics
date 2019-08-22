# frozen_string_literal: true

require_relative 'manufacturer_module'

class TrainCar
  include Manufacturer

  attr_reader :type, :number

  def initialize(args = {})
    @number = args[:number]
    @type = args[:type]
  end

end
