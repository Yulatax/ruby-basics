require_relative 'train'

class CargoTrain < Train

  @counter = 0

  def initialize(number)
    @type = cargo_train_type
    super(number, @type)
  end

  private

  def cargo_train_type
    'cargo'
  end

end


