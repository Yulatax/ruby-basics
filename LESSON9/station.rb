# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  extend Validation
  extend Accessors

  attr_reader :trains
  strong_attr_accessor :name, String

  @@all_stations = []

  NAME_FORMAT = /^[a-z][a-z '-]+$/i.freeze

  validate :name, :presence
  validate :name, :format, format: NAME_FORMAT

  class << self
    def all
      @@all_stations
    end
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << self
    register_instance
  end

  def each_train
    raise 'There are no trains on station' if @trains.empty?

    @trains.each { |train| yield(train) }
  end

  def receive_train(train)
    raise 'Train is already on station!' if @trains.include?(train)

    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    quantity = @trains.count { |train| train.type == type }
    puts "On station #{@name} there are #{quantity} trains of type #{type}."
  end

  def show_trains_list
    if @trains.empty?
      puts "There are no trains at the #{@name} station"
    else
      @trains.each { |train| puts "#{train.number} : #{train.type}" }
    end
  end

end
