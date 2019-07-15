require_relative 'train_car'

class PassengerCar < TrainCar

  def initialize(number)
    @type = pass_car_type
    super(number, @type)
  end

  private

  def pass_car_type
    'pass'
  end

end


