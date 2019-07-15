require_relative 'manufacturer_module'

class TrainCar
  include Manufacturer

  attr_reader :type, :number

  def initialize(number, type)
    @number = number
    @type = type
  end

end



