# frozen_string_literal: true

class MainInterface
  attr_reader :stations, :trains, :routes, :cars

  def initialize
    @stations = Station.all
    @trains = []
    @routes = []
    @cars = []
  end

  def main
    loop do
      choice = menu.to_i
      break if choice.zero?

      case choice
      when 1
        create_instance('to create station', :create_station)
      when 2
        create_instance('to create train', :create_train)
      when 3
        create_instance('to create route', :create_route)
      when 4
        create_instance('to create train car', :create_train_car)
      when 5
        create_instance('to add station to route', :add_station_to_route)
      when 6
        create_instance('to delete station from route', :delete_station_from_route)
      when 7
        create_instance('to set route to train', :set_route_to_train)
      when 8
        create_instance('to add/remove train car', :manage_train_car)
      when 9
        create_instance('to move train', :move_train)
      when 10
        create_instance('to display stations list', :display_stations_list)
      when 11
        create_instance('to display trains on station', :display_trains_on_station)
      when 12
        create_instance('to take a seat/capacity in car', :take_seat_capacity_in_car)
      when 13
        create_instance('to display_train_info', :display_train_info)
      else
        puts 'Choose action or enter 0 to exit'
      end
    end
  end

  def to_string
    output = "\nStations:\n"
    @stations.each { |station| output += "\t#{station.name}\n" }
    output += "\nTrains:\n"
    @trains.each { |train| output += "\t#{train.number}: #{train.type}\n" }
    output += "\nRoutes:\n"
    @routes.each { |route| output += "\t#{route.number}: #{route.start_station.name} - #{route.end_station.name}\n" }
    output += "\nCars:\n"
    @cars.each { |car| output += "\t#{car.number}: #{car.type}\n" }
    puts output
  end

  private

  def menu
    puts "\nEnter the action number:
  1 - create station
  2 - create train
  3 - create route
  4 - create train car
  5 - add inner station to route
  6 - delete inner station from route
  7 - set route to the train
  8 - add/remove train car
  9 - move train
  10 - display stations list
  11 - display trains on the station
  12 - take a seat/capacity in car
  13 - display_train_info
  0 - exit
  \n"
    gets.chomp
  end

  def string_invalid?(str)
    str.nil? || str.strip.empty?
  end

  def create_instance(action, callback)
    loop do
      puts "Do you want #{action}? If yes, enter y"
      reply = gets.chomp.downcase
      break if reply != 'y'

      send(callback)
    end
  end

  def station_exist?(name)
    @stations.any? { |station| station.name == name }
  end

  def train_exist?(number)
    !find_train(number).nil?
  end

  def route_exist?(number)
    @routes.any? { |route| route.number == number }
  end

  def car_exist?(number)
    @cars.any? { |car| car.number == number }
  end

  def find_station(name)
    @stations.find { |station| station.name == name }
  end

  def find_route(number)
    @routes.find { |route| route.number == number }
  end

  def find_train(number)
    Train.find(number)
  end

  def find_train_car(number)
    @cars.find { |car| car.number == number }
  end

  def create_station
    puts 'Enter station name: '
    name = gets.chomp.downcase
    station_creation(name)
    puts "Station #{name} created successfully!"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def station_creation(name)
    raise "Station #{name} is already exist!" if station_exist?(name)

    Station.new(name)
  end

  def create_train
    puts 'Enter train number: '
    train_number = gets.chomp
    puts 'Enter train type: cargo/pass'
    type = gets.chomp.downcase
    train = train_creation(train_number, type)
    @trains << train
    puts "Train #{train_number} - #{type} created successfully!"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def train_creation(number, type)
    raise 'Incorrect type!' if type != 'cargo' && type != 'pass'
    raise "Train #{number} is already exist!" if train_exist?(number)

    init_train(type, number)
  end

  def init_train(type, number)
    type == 'cargo' ? CargoTrain.new(number) : PassengerTrain.new(number)
  end

  def create_route
    puts 'Enter route number: '
    route_number = gets.chomp
    puts 'Enter the name of the first station in the route: '
    first_station = gets.chomp.downcase
    puts 'Enter the name of the last station in the route: '
    last_station = gets.chomp.downcase
    route = route_creation(route_number, first_station, last_station)
    @routes << route
    puts "Route #{first_station} - #{last_station} created successfully!"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def route_creation(number, station1, station2)
    raise "Route #{number} already exists" if route_exist?(number)
    raise 'Check if stations exist!' if
        !station_exist?(station1) || !station_exist?(station2)

    first_station = find_station(station1)
    last_station = find_station(station2)

    Route.new(number: number, start_station: first_station, end_station: last_station)
  end

  def create_train_car
    puts 'Enter car number: '
    car_number = gets.chomp
    puts 'Enter car type: cargo/pass'
    type = gets.chomp.downcase
    car = train_car_creation(car_number, type)
    @cars << car
    puts "Car #{car_number}: #{type} created successfully!"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def train_car_creation(number, type)
    raise 'Incorrect type!' if type != 'cargo' && type != 'pass'
    raise "Car #{number} is already exist!" if car_exist?(number)

    init_car(type, number)
  end

  def init_car(type, number)
    if type == 'cargo'
      puts 'Enter car capacity: '
      capacity = gets.chomp.to_i
      CargoCar.new(number: number, capacity: capacity)
    else
      puts 'Enter seats quantity: '
      seats = gets.chomp.to_i
      PassengerCar.new(number: number, all_seats: seats)
    end
  end

  def add_station_to_route
    puts 'Enter route number: '
    route_number = gets.chomp
    puts 'Enter station name: '
    station_name = gets.chomp.downcase
    if string_invalid?(route_number) || string_invalid?(station_name)
      puts 'Incorrect data!'
    else
      adding_station_to_route(route_number, station_name)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def adding_station_to_route(number, name)
    puts 'Index of station in the route: '
    index = gets.chomp.to_i
    station = find_station(name)
    route = find_route(number)
    raise 'Station or route not exists' if station.nil? || route.nil?

    route.add_inner_station(station, index)
    route.show_route
    puts "Station #{station.name} was successfully added to route!"
  end

  def delete_station_from_route
    puts 'Enter route number: '
    route_number = gets.chomp
    puts 'Enter station name: '
    station_name = gets.chomp.downcase
    if string_invalid?(route_number) || string_invalid?(station_name)
      puts 'Incorrect data!'
    else
      removing_station_from_route(route_number, station_name)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def removing_station_from_route(number, name)
    station = find_station(name)
    route = find_route(number)
    raise 'Station or route not exists' if station.nil? || route.nil?

    route.delete_inner_station(station)
    puts "Station #{station.name} was successfully deleted!"
    route.show_route
  end

  def set_route_to_train
    puts 'Enter route number: '
    route_number = gets.chomp
    puts 'Enter train number: '
    train_number = gets.chomp
    if string_invalid?(route_number) || string_invalid?(train_number)
      puts 'Incorrect data!'
    else
      define_route(route_number, train_number)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def define_route(route_number, train_number)
    route = find_route(route_number)
    train = find_train(train_number)
    raise 'Train or route not exists' if route.nil? || train.nil?

    train.define_route(route)
    train.route.show_route
  end

  def manage_train_car
    loop do
      puts "\n Choose action:
    - press 1 to add car
    - press 2 to remove car
    - press 0 to exit\n"

      reply = gets.chomp.to_i
      break if reply.zero?

      case reply
      when 1
        add_remove_train_car('add')
      when 2
        add_remove_train_car('remove')
      else
        puts 'Press 0 to exit'
      end
    end
  end

  def add_remove_train_car(action)
    puts 'Enter car number: '
    car_number = gets.chomp
    puts 'Enter train number: '
    train_number = gets.chomp
    puts 'Incorrect data!' if
        string_invalid?(car_number) || string_invalid?(train_number)

    action == 'add' ? adding_train_car(car_number, train_number) : removing_train_car(car_number, train_number)
  rescue RuntimeError => e
    puts e.message
  end

  def adding_train_car(car_number, train_number)
    car = find_train_car(car_number)
    train = find_train(train_number)
    raise 'Train or car not exists' if car.nil? || train.nil?

    train.add_car(car)
    p train.cars
  end

  def removing_train_car(car_number, train_number)
    car = find_train_car(car_number)
    train = find_train(train_number)
    raise 'Train or car not exists' if car.nil? || train.nil?

    train.remove_car(car)
    p train.cars
  end

  def move_train
    loop do
      puts "\n Choose direction:
    - press 1 to move forward
    - press 2 to move back
    - press 0 to exit\n"
      reply = gets.chomp.to_i
      break if reply.zero?

      case reply
      when 1
        moving('forward')
      when 2
        moving('back')
      else
        puts 'Press 0 to exit'
      end
    end
  end

  def moving(direction)
    puts 'Enter train number: '
    train_number = gets.chomp
    if string_invalid?(train_number)
      puts 'Incorrect data!'
    else
      train = find_train(train_number)
      if train.nil?
        puts 'Train not exists'
      else
        direction == 'forward' ? train.move_forward : train.move_back
        puts "Current station - #{train.current_station.name}"
      end
    end
  end

  def display_stations_list
    @stations.each { |station| puts station.name }
  end

  def display_trains_on_station
    puts 'Enter station name: '
    name = gets.chomp.downcase
    if string_invalid?(name)
      puts 'Incorrect data!'
    else
      station_trains(name)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def station_trains(station)
    station = find_station(station)
    raise 'This station not exists' if station.nil?

    block = proc do |train|
      puts "Train #{train.number}: #{train.type},"\
           " #{train.cars.length} car/s"
    end
    station.each_train(&block)
  end

  def take_seat_capacity_in_car
    puts 'Enter a car number: '
    car_number = gets.chomp
    if string_invalid?(car_number)
      puts 'Incorrect data!'
    else
      occupy_car(car_number)
    end
  end

  def occupy_car(car_number)
    car = find_train_car(car_number)
    if car.nil?
      puts 'This car not exists'
    else
      car.type == 'pass' ? occupy_pass_car(car) : occupy_cargo_car(car)
    end
  end

  def occupy_pass_car(car)
    car.take_a_seat
    puts car.seats_occupied
  rescue RuntimeError => e
    puts e.message
  end

  def occupy_cargo_car(car)
    puts 'Enter volume: '
    volume = gets.chomp.to_i
    car.take_capacity(volume)
    puts car.capacity_occupied
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def display_train_info
    puts 'Enter a train number: '
    train_number = gets.chomp
    if string_invalid?(train_number)
      puts 'Incorrect data!'
    else
      get_train_info(train_number)
    end
  end

  def get_train_info(train_number)
    train = find_train(train_number)
    if train.nil?
      puts 'This train not exists'
    else
      train.type == 'cargo' ? cargo_train_info(train) : pass_train_info(train)
    end
  end

  def cargo_train_info(train)
    block = proc do |car|
      puts "Car #{car.number}: #{car.type},"\
           " available - #{car.capacity_available},"\
           " occupied - #{car.capacity_occupied}"
    end
    train.each_car(&block)
  end

  def pass_train_info(train)
    block = proc do |car|
      puts "Car #{car.number}: #{car.type},"\
           " available - #{car.free_seats}, occupied - #{car.seats_occupied}"
    end
    train.each_car(&block)
  end
end
