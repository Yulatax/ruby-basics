# frozen_string_literal: true

require_relative 'train_car'
require_relative 'validation'

class CargoCar < TrainCar
  include Validation

  attr_reader :capacity_occupied

  NUMBER_FORMAT = /^\d{3}$/.freeze

  validate :number, :presence
  validate :number, :format, format: NUMBER_FORMAT

  def initialize(args = {})
    @number = args[:number]
    validate!
    @type = cargo_car_type
    @capacity = args[:capacity] || 0
    @capacity_occupied = 0
    super(number: @number, type: @type)
  end

  def take_capacity(volume)
    raise('Car capacity has exceed') unless volume <= capacity_available

    @capacity_occupied += volume
  end

  def capacity_available
    @capacity - @capacity_occupied
  end

  private

  def cargo_car_type
    'cargo'
  end
end
