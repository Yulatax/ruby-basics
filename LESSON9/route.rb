# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  attr_reader :start_station, :end_station, :inner_stations, :number

  ROUTE_NUMBER_FORMAT = /^\d{3}$/.freeze

  validate :number, :presence
  validate :number, :format, format: ROUTE_NUMBER_FORMAT
  validate :start_station, :type, class: Station
  validate :end_station, :type, class: Station

  def initialize(args = {})
    @number = args[:number]
    @start_station = args[:start_station]
    @end_station = args[:end_station]
    @inner_stations = args[:inner_stations] || []
    validate!
    same_stations?
    register_instance
  end

  def add_inner_station(station, index)
    raise 'Error of adding station' if
        station_exists?(station) || first_station?(station) || last_station?(station)

    @inner_stations = @inner_stations.insert(index, station).compact
  end

  def delete_inner_station(station)
    raise 'Error of removing station' if
        !station_exists?(station) || first_station?(station) || last_station?(station)

    @inner_stations.delete(station)
  end

  def show_route
    output = "Route #{@number}: \n"
    stations_list.each { |station| output += "#{station.name} " }
    puts output
  end

  def stations_list
    [start_station, inner_stations, end_station].flatten!.compact
  end

  protected

  def first_station?(station)
    station == @start_station
  end

  def last_station?(station)
    station == @end_station
  end

  def station_exists?(station)
    @inner_stations.include?(station)
  end

  def same_stations?
    raise 'Start and end stations are the same' if
         @start_station == @end_station
  end
end

