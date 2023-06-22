# A simple and light interface to interact with GPIO pins of the Raspberry Pi.
#   Guide and source code : https://github.com/sergio1990/raspi-gpio-rb
#
# @author exybore, sergio1990
#
# @example Common usage
#   pin = GPIO.new(12, GPIO::OUT)
#   pin.value = GPIO::LOW
#   pin.mode = GPIO::IN
#   pin.value # => either LOW or HIGH
#   pin.cleanup
#
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

  # Exception to handle cases when trying to work with the pin which was
  # already cleaned up
  class NotExportedError < BaseError
  end

  attr_reader :mode

  # Initialize the GPIO pin
  #
  # @param pin [Integer] GPIO pin number to use
  # @param mode [String] pin mode : IN or OUT
  def initialize(pin, _mode = OUT)
    @pin = pin

    unexport_pin
    export_pin
    @exported = true

    self.mode = _mode
  end

  # Set the pin mode
  #
  # @param mode [String] pin mode : IN or OUT
  # @raise [NotExportedError] if the pin was already cleaned up
  # @raise [UnknownModeError] if the mode isn't IN or OUT
  def mode=(new_mode)
    raise NotExportedError, "gpio error : pin was already cleaned up" unless exported
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
  # @raise [NotExportedError] if the pin was already cleaned up
  # @raise [NotOutModeError] if the pin isn't in OUT mode
  # @raise [BadValueError] if the provided value isn't LOW or HIGH
  def value=(new_value)
    raise NotExportedError, "error : pin was already cleaned up" unless exported
    raise NotOutModeError, "error : mode isn't OUT" unless @mode == OUT
    raise BadValueError, "error : bad pin value" unless PIN_VALUES.include?(new_value)

    File.open("#{LIB_PATH}/gpio#{@pin}/value", 'w') do |file|
      file.write(new_value)
    end
  end

  # Cleans up the pin by unexporting it
  def cleanup
    unexport_pin
    @exported = false
  end

  private

  attr_reader :exported

  def unexport_pin
    File.open("#{LIB_PATH}/unexport", 'w') do |file|
      file.write(@pin)
    end
  rescue Errno::EINVAL
    # Do nothing - the pin is already unexported
  end

  def export_pin
    File.open("#{LIB_PATH}/export", 'w') do |file|
      file.write(@pin)
    end
  end
end
