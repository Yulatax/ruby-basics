class Station
  attr_reader :trains, :station_name

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end

  def trains_by_type
    trains_hash = {}
    @trains.each do |train|
      type = train.train_type.to_sym
      if trains_hash.keys.include?(type)
        trains_hash[type] += 1
      else
        trains_hash[type] = 1
      end
    end
    puts trains_hash
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
        station.station_name == @start_station.station_name ||
        station.station_name == @end_station.station_name
    @inner_stations.insert(index, station)
  end

  def delete_inner_station(station)
    @inner_stations.delete(station) if @inner_stations.include?(station)
  end

  def show_route
    route = [start_station, inner_stations, end_station].flatten!.compact
    route.each {|station| puts "#{station.station_name}"}
  end

end


class Train
  attr_accessor :speed, :current_station, :route
  attr_reader :cars_count, :train_type

  def initialize(train_number, train_type, cars_count)
    @train_number = train_number
    @train_type = train_type
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
    @route_stations = [@route.start_station, @route.inner_stations, @route.end_station].flatten!.compact
  end

  def move_forward
    return unless @route || @current_station == @route_stations.last
    @station_index += 1
    @current_station = @route_stations[@station_index]
  end

  def move_back
    return unless @route || @current_station == @route_stations.first
    @station_index -= 1
    @current_station = @route_stations[@station_index]
  end

  def stations_around
    return unless @route
    index = @station_index - 1
    if index < 0 || index == @route_stations.size - 1
      index = 0
      closest_stations = @route_stations.slice(index, 2)
    else
      closest_stations = @route_stations.slice(index, 3)
    end
    closest_stations.each {|station| puts station.station_name}
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
p train111c.route
p train111c.current_station
train111c.stations_around
train111c.move_forward
p train111c.current_station
train111c.stations_around
train111c.move_forward
train111c.move_forward
train111c.move_forward
p train111c.current_station
train111c.move_back
p train111c.current_station

station_nvb.receive_train(train111c)
station_nvb.receive_train(train222c)
station_nvb.receive_train(train333p)
station_nvb.receive_train(train444p)
station_nvb.trains_by_type
station_nvb.send_train(train222c)
station_nvb.trains_by_type
