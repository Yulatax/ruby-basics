# frozen_string_literal: true

require_relative 'train_car'

class CargoCar < TrainCar
  attr_reader :capacity_occupied

  def initialize(args = {})
    @type = cargo_car_type
    @number = args[:number]
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

# p cargo_car1 = CargoCar.new(number: '111', capacity: 1000)
# def occupy_car(car, volume)
#   begin
#     car.take_capacity(volume)
#     p car.capacity_available
#   rescue RuntimeError => e
#     puts e.message
#   end
# end
# occupy_car(cargo_car1, 900)
# occupy_car(cargo_car1, 100)
# occupy_car(cargo_car1, 100)