# frozen_string_literal: true

require_relative 'manufacturer_module'
require_relative 'validation_module'

class TrainCar
  include Manufacturer
  include ValidationModule

  attr_reader :type, :number

  NUMBER_FORMAT = /^\d{3}$/.freeze

  def initialize(args = {})
    @number = args[:number]
    validate_number!
    @type = args[:type]
    validate_type!
  end

  protected

  def validate!
    validate_number! && validate_type!
  end

  def validate_number!
    raise "Car number can't be empty" if @number.nil?
    raise 'Car number format contains 3 digits only' if @number !~ NUMBER_FORMAT
  end

  def validate_type!
    raise "Type should be 'cargo' or 'pass'" if
        @type != 'cargo' && @type != 'pass'
  end
end
