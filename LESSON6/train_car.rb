require_relative 'manufacturer_module'

class TrainCar
  include Manufacturer

  attr_reader :type, :number

  NUMBER_FORMAT = /^\d{3}$/

  def initialize(number, type)
    @number = number
    validate_number!
    @type = type
    validate_type!
  end

  def valid?
    return true if validate_number! && validate_type!
  rescue
    false
  end

  protected

  def validate_number!
    raise "Car number can't be empty" if @number.nil?
    raise "Car number format contains 3 digits only" if @number !~ NUMBER_FORMAT
  end

  def validate_type!
    raise "Type should be 'cargo' or 'pass'" if @type != 'cargo' && @type != 'pass'
  end
end


