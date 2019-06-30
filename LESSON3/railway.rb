class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    quantity = @trains.count{|train| train.type == type}
    puts "On station #{@name} there are #{quantity} trains of type #{type}."
  end
end

class Route
  attr_reader :start_station, :end_station, :inner_stations

  def initialize(start_station, end_station, inner_stations = [])
    @start_station = start_station
    @end_station = end_station
    @inner_stations = inner_stations
  end

  def add_inner_station(station, index)
    return if @inner_stations.include?(station) ||
        station == @start_station ||
        station == @end_station
    @inner_stations.insert(index, station)
  end

  def delete_inner_station(station)
    @inner_stations.delete(station)
  end

  def stations_list
    [start_station, inner_stations, end_station].flatten!.compact
  end

  def show_route
    stations_list.each {|station| puts "#{station.name}"}
  end
end


class Train
  attr_accessor :speed, :current_station, :route
  attr_reader :cars_count, :type

  def initialize(number, type, cars_count)
    @number = number
    @type = type
    @cars_count = cars_count
    @speed = 0
  end

  def increase_speed(speed_acceleration)
    @speed += speed_acceleration
  end

  def stop
    @speed = 0
  end

  def add_car
    @cars_count += 1 if @speed == 0
  end

  def remove_car
    @cars_count -= 1 if @speed == 0 && @cars_count > 0
  end

  def set_route(route)
    @route = route
    @current_station = route.start_station
    @station_index = 0
    @current_station.receive_train(self)
  end

  def next_station
    return unless @route || current_station == @route.stations_list.last
    @route.stations_list[@station_index + 1]
  end

  def previous_station
    return unless @route || current_station == @route.stations_list.first
    @route.stations_list[@station_index - 1]
  end

  def move_forward
    return unless @route || @current_station == @route.stations_list.last
    @station_index += 1
    @current_station = @route.stations_list[@station_index]
    @current_station.receive_train(self)
    previous_station.send_train(self)
  end

  def move_back
    return unless @route || @current_station == @route.stations_list.first
    @station_index -= 1
    @current_station = @route.stations_list[@station_index]
    @current_station.receive_train(self)
    next_station.send_train(self)
  end
end

station_kja = Station.new("Krasnoyarsk")
station_ack = Station.new("Achinsk")
station_nvb = Station.new("Novosibirsk")
station_bgt = Station.new("Bogotol")
station_oms = Station.new("Omsk")
station_ekb = Station.new("Ekaterinburg")
station_mow = Station.new("Moscow")

route_kja_mow = Route.new(station_kja, station_mow, [station_ack, station_bgt])
route_kja_mow.show_route
route_kja_mow.add_inner_station(station_nvb, 3)
route_kja_mow.add_inner_station(station_ekb, 5)
route_kja_mow.add_inner_station(station_oms, 4)
route_kja_mow.show_route
route_kja_mow.delete_inner_station(station_bgt)
route_kja_mow.show_route

train111c = Train.new('111c', 'cargo', 58)
train222c = Train.new('222c', 'cargo', 47)
train333p = Train.new('333p', 'pass', 18)
train444p = Train.new('444p', 'pass', 12)

train111c.increase_speed(20)
puts train111c.speed
train111c.stop
puts train111c.speed
train111c.add_car
puts train111c.cars_count
train111c.remove_car
puts train111c.cars_count
train111c.set_route(route_kja_mow)
train111c.route.show_route
train111c.current_station.trains_by_type('cargo')
p train111c.next_station.name
train111c.move_forward
p train111c.current_station
p train111c.next_station

train111c.move_forward
train111c.move_forward
train111c.move_forward
p train111c.current_station.name
train111c.current_station.trains_by_type('cargo')
train111c.move_back
p train111c.current_station.name
train111c.current_station.trains_by_type('cargo')
train111c.next_station.trains_by_type('cargo')

station_nvb.receive_train(train222c)
station_nvb.receive_train(train333p)
station_nvb.receive_train(train444p)
station_nvb.trains_by_type('cargo')
station_nvb.send_train(train222c)
station_nvb.trains_by_type('pass')

