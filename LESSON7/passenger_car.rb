require_relative 'train_car'

class PassengerCar < TrainCar
  attr_reader :seats_occupied

  def initialize(number, all_seats)
    @type = pass_car_type
    @all_seats = all_seats
    @seats_occupied = 0
    super(number, @type)
  end

  def take_a_seat
    if @seats_occupied < @all_seats
      @seats_occupied += 1
    else
      raise('There are no available seats!')
    end
  end

  def free_seats
    @all_seats - @seats_occupied
  end

  private

  def pass_car_type
    'pass'
  end


end
