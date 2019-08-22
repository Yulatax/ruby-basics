# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    @type = cargo_train_type
    super(number: number, type: @type)
  end

  private

  def cargo_train_type
    'cargo'
  end
end
