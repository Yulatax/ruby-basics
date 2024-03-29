# frozen_string_literal: true

require_relative 'manufacturer_module'
require_relative 'instance_counter'
require_relative 'validation_module'
require_relative 'train_car'
require_relative 'route'
require_relative 'station'

class Train
  include Manufacturer
  include InstanceCounter
  include ValidationModule

  attr_accessor :current_station, :route, :speed
  attr_reader :type, :cars, :number

  @@all_trains = {}

  TRAIN_NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  def initialize(args = {})
    @number = args[:number]
    validate_number!
    @type = args[:type]
    validate_type!
    @speed = 0
    @cars = []
    @@all_trains[@number] = self
    register_instance
  end

  class << self
    def find(value)
      @@all_trains[value]
    end
  end

  def each_car
    return if @cars.empty?

    @cars.each { |car| yield(car) }
  end

  def increase_speed(speed_acceleration)
    @speed += speed_acceleration
  end

  def stop
    return if train_stopped?

    @speed = 0
  end

  def add_car(car)
    raise 'Error of car adding' if cannot_add_car?(car)

    @cars = @cars.push(car)
  end

  def remove_car(car)
    raise 'Error of car removing' if @cars.empty? || !train_stopped?

    @cars.delete(car)
  end

  def define_route(route)
    @route = route
    @current_station = route.start_station
    @station_index = 0
    @current_station.receive_train(self)
  end

  def next_station
    return if @route.nil? || last_station?

    @route.stations_list[@station_index + 1]
  end

  def previous_station
    return if @route.nil? || first_station?

    @route.stations_list[@station_index - 1]
  end

  def move_forward
    return unless next_station

    @station_index += 1
    move_train(@station_index)
  end

  def move_back
    return unless previous_station

    @station_index -= 1
    move_train(@station_index)
  end

  protected

  def validate!
    validate_number! && validate_type!
  end

  def validate_number!
    raise "Train number can't be empty" if @number.nil?
    raise "Train number doesn't match format" if @number !~ TRAIN_NUMBER_FORMAT
  end

  def validate_type!
    raise "Type should be 'cargo' or 'pass'" if
        @type != 'cargo' && @type != 'pass'
  end

  private

  def car_train_same_type?(car)
    @type == car.type
  end

  def train_stopped?
    @speed.zero?
  end

  def can_add_car?(car)
    train_stopped? && car_train_same_type?(car) && !@cars.include?(car)
  end

  def cannot_add_car?(car)
    !can_add_car?(car)
  end

  def last_station?
    @current_station == @route.stations_list.last
  end

  def first_station?
    @current_station == @route.stations_list.first
  end

  def move_train(index)
    @current_station = @route.stations_list[index]
    @current_station.receive_train(self)
    previous_station.send_train(self)
  end
end
