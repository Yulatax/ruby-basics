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
      break if choice == 0

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
      else
        puts "Choose action or enter 11 to exit"
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
      break if reply != "y"
      send(callback)
    end
  end

  def station_exist?(name)
    @stations.any?{ |station| station.name == name }
  end

  def train_exist?(number)
    !find_train(number).nil?
  end

  def route_exist?(number)
    @routes.any?{ |route| route.number == number }
  end

  def car_exist?(number)
    @cars.any?{ |car| car.number == number}
  end

  def find_station(name)
    @stations.find{ |station| station.name == name }
  end

  def find_route(number)
    @routes.find{ |route| route.number == number }
  end

  def find_train(number)
    Train.find(number)
  end

  def find_train_car(number)
    @cars.find{ |car| car.number == number }
  end

  def create_station
    puts "Enter station name: "
    name = gets.chomp.downcase
    station_creation(name)
  end

  def station_creation(name)
    if station_exist?(name)
      puts "Station #{name} is already exist!"
    else
      begin
        station = Station.new(name)
        puts "Station #{station.name} created successfully!"
      rescue RuntimeError => e
        puts e.inspect
      end
    end
  end

  def create_train
    puts "Enter train number: "
    train_number = gets.chomp
    puts "Enter train type: cargo/pass"
    type = gets.chomp.downcase
    if type != 'cargo' && type != 'pass'
      puts "Incorrect type!"
    else
      train_creation(train_number, type)
    end
  end

  def train_creation(number, type)
    if train_exist?(number)
      puts "Train #{number} is already exist!"
    else
      begin
        train = init_train(type, number)
        @trains << train
        puts "Train #{train.number} - #{train.type} created successfully!"
      rescue RuntimeError => e
      puts e.inspect
      end
    end
  end

  def init_train(type, number)
    if type == 'cargo'
      CargoTrain.new(number)
    else
      PassengerTrain.new(number)
    end
  end

  def create_route
    puts "Enter route number: "
    route_number = gets.chomp
    puts "Enter the name of the first station in the route: "
    first_station = gets.chomp.downcase
    puts "Enter the name of the last station in the route: "
    last_station = gets.chomp.downcase
    route_creation(route_number, first_station, last_station)
  end

  def route_creation(number, station1, station2)
    if route_exist?(number)
      puts "Route #{number} already exists"
    elsif !station_exist?(station1) || !station_exist?(station2)
      puts "Check if stations exist!"
    else
      begin
        route = Route.new(number, find_station(station1), find_station(station2))
        @routes << route
        puts "Route #{station1} - #{station2} created successfully!"
      rescue RuntimeError => e
        puts e.inspect
      end
    end
  end

  def create_train_car
    puts "Enter car number: "
    car_number = gets.chomp
    puts "Enter car type: cargo/pass"
    type = gets.chomp.downcase
    if type != 'cargo' && type != 'pass'
      puts "Incorrect type!"
    else
      train_car_creation(car_number, type)
    end
  end

  def train_car_creation(number, type)
    if car_exist?(number)
      puts "Car #{number} is already exist!"
    else
      begin
        car = init_car(type, number)
        @cars << car
        puts "Car #{car.number}: #{car.type} created successfully!"
      rescue RuntimeError => e
        puts e.inspect
      end
    end
  end

  def init_car(type, number)
    if type == 'cargo'
      CargoCar.new(number)
    else
      PassengerCar.new(number)
    end
  end

  def add_station_to_route
    puts "Enter route number: "
    route_number = gets.chomp.to_i
    puts "Enter station name: "
    station_name = gets.chomp.downcase
    if route_number.zero? || string_invalid?(station_name)
      puts "Incorrect data!"
    else
      adding_station_to_route(route_number, station_name)
    end
  end

  def adding_station_to_route(number, name)
    puts "Index of station in the route: "
    index = gets.chomp.to_i
    station = find_station(name)
    route = find_route(number)
    if station.nil? || route.nil?
      puts "Station or route not exists"
    else
      if route.add_inner_station(station, index).nil?
        puts "Error of adding station!"
      else
        puts "Station #{station.name} was successfully added to the route!"
        route.show_route
      end
    end
  end

  def delete_station_from_route
    puts "Enter route number: "
    route_number = gets.chomp.to_i
    puts "Enter station name: "
    station_name = gets.chomp.downcase
    if route_number.zero? || string_invalid?(station_name)
      puts "Incorrect data!"
    else
      removing_station_from_route(route_number, station_name)
    end
  end

  def removing_station_from_route(number, name)
    station = find_station(name)
    route = find_route(number)
    if station.nil? || route.nil?
      puts "Station or route not exists"
    else
      if route.delete_inner_station(station).nil?
        puts "There is no such station in this route"
      else
        puts "Station #{station.name} was successfully deleted!"
        route.show_route
      end
    end
  end

  def set_route_to_train
    puts "Enter route number: "
    route_number = gets.chomp.to_i
    puts "Enter train number: "
    train_number = gets.chomp.to_i
    if route_number.zero? || train_number.zero?
      puts "Incorrect data!"
    else
      route = find_route(route_number)
      train = find_train(train_number)
      if route.nil? || train.nil?
        puts "Train or route not exists"
      else
        train.set_route(route)
        train.route.show_route
      end
    end
  end

  def manage_train_car
    loop do
      puts "\n Choose action:
    - press 1 to add car
    - press 2 to remove car
    - press 0 to exit\n"

      reply = gets.chomp.to_i
      break if reply == 0

      case reply
      when 1
        add_remove_train_car("add")
      when 2
        add_remove_train_car("remove")
      else
        puts "Press 0 to exit"
      end
    end
  end

  def add_remove_train_car(action)
    puts "Enter car number: "
    car_number = gets.chomp.to_i
    puts "Enter train number: "
    train_number = gets.chomp.to_i
    if car_number.zero? || train_number.zero?
      puts "Incorrect data!"
    else
      if action == "add"
        adding_train_car(car_number, train_number)
      else
        removing_train_car(car_number, train_number)
      end
    end
  end

  def adding_train_car(car_number, train_number)
    car = find_train_car(car_number)
    train = find_train(train_number)
    if car.nil? || train.nil?
      puts "Train or car not exists"
    else
      puts "Index of car in the train: "
      index = gets.chomp.to_i
      train.add_car(car, index)
      p train.cars
    end
  end

  def removing_train_car(car_number, train_number)
    car = find_train_car(car_number)
    train = find_train(train_number)
    if car.nil? || train.nil?
      puts "Train or car not exists"
    else
      if train.remove_car(car).nil?
        puts "There is no shuch car in this train"
      else
        puts "The car was successfully deleted!"
      end
      p train.cars
    end
  end

  def move_train
    loop do
      puts "\n Choose direction:
    - press 1 to move forward
    - press 2 to move back
    - press 0 to exit\n"
      reply = gets.chomp.to_i
      break if reply == 0

      case reply
      when 1
        moving("forward")
      when 2
        moving("back")
      else
        puts "Press 0 to exit"
      end
    end
  end

  def moving(direction)
    puts "Enter train number: "
    train_number = gets.chomp.to_i
    if train_number.zero?
      puts "Incorrect data!"
    else
      train = find_train(train_number)
      if train.nil?
        puts "Train not exists"
      else
        if direction == "forward"
          train.move_forward
        else
          train.move_back
        end
        puts "Current station - #{train.current_station.name}"
      end
    end
  end

  def display_stations_list
    @stations.each {|station| puts station.name}
  end

  def display_trains_on_station
    puts "Enter station name: "
    name = gets.chomp.downcase
    if string_invalid?(name)
      puts "Incorrect data!"
    else
      station = find_station(name)
      if station.nil?
        puts "This station not exists"
      else
        station.show_trains_list
      end
    end
  end
end

