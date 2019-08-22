# frozen_string_literal: true

require_relative 'train_car'

class PassengerCar < TrainCar
  attr_reader :seats_occupied

  def initialize(args = {})
    @type = pass_car_type
    @number = args[:number]
    @all_seats = args[:all_seats] || 0
    @seats_occupied = 0
    super(number: @number, type: @type)
  end

  def take_a_seat
    raise('There are no available seats!') unless free_seats >= 1

    @seats_occupied += 1
  end

  def free_seats
    @all_seats - @seats_occupied
  end

  private

  def pass_car_type
    'pass'
  end
end
