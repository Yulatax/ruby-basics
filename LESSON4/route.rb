class Route

  attr_reader :start_station, :end_station, :inner_stations, :number

  def initialize(number, start_station, end_station, inner_stations = [])
    @number = number
    @start_station = start_station
    @end_station = end_station
    @inner_stations = inner_stations
  end

  def add_inner_station(station, index)
    return if @inner_stations.include?(station) ||
        station == @start_station ||
        station == @end_station
    @inner_stations = @inner_stations.insert(index, station).compact
  end

  def delete_inner_station(station)
    @inner_stations.delete(station)
  end

  def show_route
    output = "Route #{@number}: \n"
    stations_list.each {|station| output += "#{station.name} "}
    puts output
  end

  def stations_list
    [start_station, inner_stations, end_station].flatten!.compact
  end

end
