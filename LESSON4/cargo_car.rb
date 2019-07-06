require_relative 'train_car'

class CargoCar < TrainCar

  def initialize(number)
    @type = CARGO_CAR_TYPE
    super(number, @type)
  end

  private

  CARGO_CAR_TYPE = "cargo"

end

