require_relative 'train'

class CargoTrain < Train

  def initialize(number)
    @type = CARGO_TRAIN_TYPE
    super(number, @type)
  end

  private

  CARGO_TRAIN_TYPE = "cargo"

end


