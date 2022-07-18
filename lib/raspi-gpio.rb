# raspi-gpio - A simple and light interface to interact with GPIO pins of the Raspberry Pi.
#   Guide and source code : https://github.com/exybore/raspi-gpio-rb
#   Documentation : https://rubydoc.info/gems/raspi-gpio
#
# @author exybore

# Main class, to manage GPIO pins
class GPIO
  # GPIO core library path
  LIB_PATH = '/sys/class/gpio'

  # Shortcut for low pin value (0)
  LOW = 0

  # Shortcut for high pin value (1)
  HIGH = 1

  # Specifies all possible pin values
  PIN_VALUES = [
    LOW,
    HIGH
  ]

  # Shortcut for 'in' pin mode
  IN = 'in'

  # Shortcut for 'out' pin mode
  OUT = 'out'

  # Specifies all possible pin modes
  PIN_MODES = [
    IN,
    OUT
  ]

  # Base error for all other GPIO related errors
  class BaseError < StandardError
  end

  # Exception to handle unknown pin mode (not IN or OUT)
  class UnknownModeError < BaseError
  end

  # Exception to handle pin writing when not in OUT mode
  class NotOutModeError < BaseError
  end

  # Exception to handle bad pin value (not LOW or HIGH)
  class BadValueError < BaseError
  end

  attr_reader :mode

  # Initialize the GPIO pin
  #
  # @param pin [Integer] GPIO pin number to use
  # @param mode [String] pin mode : IN or OUT
  def initialize(pin, mode = OUT)
    @pin = pin
    begin
      File.open("#{LIB_PATH}/unexport", 'w') do |file|
        file.write(@pin)
      end
    rescue Errno::EINVAL
      # Do nothing - the pin is already unexported
    end
    File.open("#{LIB_PATH}/export", 'w') do |file|
      file.write(@pin)
    end
    @mode = mode
  end

  # Set the pin mode
  #
  # @param mode [String] pin mode : IN or OUT
  # @raise [UnknownMode] if the mode isn't IN or OUT
  def mode=(new_mode)
    raise UnknownModeError, "gpio error : unknown mode #{new_mode}" unless PIN_MODES.include?(new_mode)

    File.open("#{LIB_PATH}/gpio#{@pin}/direction", 'w') do |file|
      file.write(mode)
    end

    @mode = new_mode
  end

  # Read the value of the pin
  #
  # @return [Integer] pin's value : 0 or 1
  def value
    File.open("#{LIB_PATH}/gpio#{@pin}/value", 'r').read
  end

  # Set a value to the pin
  #   This method can only be used when the pin is in OUT mode
  #
  # @param new_value [Integer] the value : LOW or HIGH
  # @raise [NotOutMode] if the pin isn't in OUT mode
  # @raise [BadValue] if the provided value isn't LOW or HIGH
  def value=(new_value)
    raise NotOutModeError, "error : mode isn't OUT" unless @mode == OUT
    raise BadValueError, "error : bad pin value" unless PIN_VALUE.include?(new_value)

    File.open("#{LIB_PATH}/gpio#{@pin}/value", 'w') do |file|
      file.write(new_value)
    end
  end
end
