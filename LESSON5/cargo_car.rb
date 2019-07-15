require_relative 'train_car'

class CargoCar < TrainCar

  def initialize(number)
    @type = cargo_car_type
    super(number, @type)
  end

  private

  def cargo_car_type
    'cargo'
  end

end

