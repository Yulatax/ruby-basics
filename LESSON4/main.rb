require_relative 'station'
require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_car'
require_relative 'passenger_car'
require_relative 'main_interface'

interface = MainInterface.new
interface.main
interface.to_string
