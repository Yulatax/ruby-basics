# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    @type = pass_train_type
    super(number: number, type: @type)
  end

  private

  def pass_train_type
    'pass'
  end
end
