require_relative 'instance_counter'
require_relative 'station'

class Route

  include InstanceCounter

  attr_reader :start_station, :end_station, :inner_stations, :number

  ROUTE_NUMBER_FORMAT = /^\d{3}$/

  def initialize(number, start_station, end_station, inner_stations = [])
    @number = number
    validate_number!
    @start_station = start_station
    @end_station = end_station
    @inner_stations = inner_stations
    validate_station!
    register_instance
  end

  def valid?
    return true if validate_number! && validate_station!
  rescue
    false
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

  protected

  def validate_number!
    raise "Route number can't be empty" if @number.nil?
    raise "Route number format contains 3 digits only" if @number !~ ROUTE_NUMBER_FORMAT
  end

  def validate_station!
    raise "Start and end stations are the same" if @start_station == @end_station
    raise "Start or end station is not the instance of class Station" if
      !@start_station.instance_of?(Station) || !@end_station.instance_of?(Station)
  end
end


