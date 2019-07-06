require_relative 'train'

class PassengerTrain < Train

  def initialize(number)
    @type = PASS_TRAIN_TYPE
    super(number, @type)
  end

  private

  PASS_TRAIN_TYPE = "pass"

end

