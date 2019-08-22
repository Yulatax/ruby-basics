# frozen_string_literal: true

require_relative 'train'
require_relative 'validation'

class CargoTrain < Train
  include Validation

  TRAIN_NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/.freeze

  validate :number, :presence
  validate :number, :format, format: TRAIN_NUMBER_FORMAT

  def initialize(number)
    @number = number
    validate!
    @type = cargo_train_type
    super(number: @number, type: @type)
  end

  private

  def cargo_train_type
    'cargo'
  end
end
