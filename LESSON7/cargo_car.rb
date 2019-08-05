require_relative 'train_car'

class CargoCar < TrainCar
  attr_reader :capacity_occupied

  def initialize(number, capacity)
    @type = cargo_car_type
    @capacity = capacity
    @capacity_occupied = 0
    super(number, @type)
  end

  def take_capacity(volume)
    if volume <= capacity_available
      @capacity_occupied += volume
    else
      raise("Car capacity has exceed")
    end
  end

  def capacity_available
    @capacity - @capacity_occupied
  end

  private

  def cargo_car_type
    'cargo'
  end

end



