# frozen_string_literal: true

require_relative 'train_car'
require_relative 'validation'

class PassengerCar < TrainCar
  include Validation

  attr_reader :seats_occupied

  NUMBER_FORMAT = /^\d{3}$/.freeze

  validate :number, :presence
  validate :number, :format, format: NUMBER_FORMAT


  def initialize(args = {})
    @number = args[:number]
    validate!
    @type = pass_car_type
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
