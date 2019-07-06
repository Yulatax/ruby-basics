require_relative 'train_car'

class PassengerCar < TrainCar

  def initialize(number)
    @type = PASS_CAR_TYPE
    super(number, @type)
  end

  private

  PASS_CAR_TYPE = "pass"

end

