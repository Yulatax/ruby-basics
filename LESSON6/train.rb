require_relative 'manufacturer_module'
require_relative 'instance_counter'
require_relative 'validation_module'

class Train
  include Manufacturer
  include InstanceCounter
  include ValidationModule

  @@all_trains = {}

  attr_accessor :current_station, :route, :speed
  attr_reader :type, :cars, :number

  TRAIN_NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i

  def initialize(number, type)
    @number = number
    validate_number!
    @type = type
    validate_type!
    @speed = 0
    @cars = []
    @@all_trains[@number] = self
    register_instance
  end

  class << self

    def find(number)
      @@all_trains[number]
    end
  end

  def increase_speed(speed_acceleration)
    @speed += speed_acceleration
  end

  def stop
    return if train_stopped?
    @speed = 0
  end

  def add_car(car, index)
    if !car_train_same_type?(car) || !train_stopped?
      puts "Can't add car: train is moving or car and train are not the same type"
    else
      if @cars.include?(car)
        puts "Car already exists"
      else
        @cars = @cars.insert(index, car).compact
        puts "Car was successfully added!"
      end
    end
  end

  def remove_car(car)
    if @cars.empty? || !train_stopped?
      puts "Can't remove car: train is moving or no cars"
    else
      @cars.delete(car)
    end
  end

  def set_route(route)
    @route = route
    @current_station = route.start_station
    @station_index = 0
    @current_station.receive_train(self)
  end

  def next_station
    return if @route.nil? || current_station == @route.stations_list.last
    @route.stations_list[@station_index + 1]
  end

  def previous_station
    return if @route.nil? || current_station == @route.stations_list.first
    @route.stations_list[@station_index - 1]
  end

  def move_forward
    if @route.nil? || @current_station == @route.stations_list.last
      puts "This is the last station of the route"
    else
      @station_index += 1
      @current_station = @route.stations_list[@station_index]
      @current_station.receive_train(self)
      previous_station.send_train(self)
    end
  end

  def move_back
    if @route.nil? || @current_station == @route.stations_list.first
      puts "This is the first station of the route"
    else
      @station_index -= 1
      @current_station = @route.stations_list[@station_index]
      @current_station.receive_train(self)
      next_station.send_train(self)
    end
  end

  protected

  def validate!
    validate_number! && validate_station!
  end

  def validate_number!
    raise "Train number can't be empty" if @number.nil?
    raise "Train number doesn't match format" if @number !~ TRAIN_NUMBER_FORMAT
  end

  def validate_type!
    raise "Type should be 'cargo' or 'pass'" if @type != 'cargo' && @type != 'pass'
  end

  private

  def car_train_same_type?(car)
    @type == car.type
  end

  def train_stopped?
    @speed.zero?
  end

end
