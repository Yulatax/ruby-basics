class Train
  attr_accessor :current_station, :route, :speed
  attr_reader :type, :cars, :number

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @cars = []
  end

  def increase_speed(speed_acceleration)
    @speed += speed_acceleration
  end

  def stop
    if train_stopped?
      puts "Train is already stopped"
    else
      @speed = 0
    end
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

  private

  def car_train_same_type?(car)
    @type == car.type
  end

  def train_stopped?
    @speed.zero?
  end

end

