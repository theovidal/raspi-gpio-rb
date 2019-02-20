# GPIO core library path
LIB_PATH = '/sys/class/gpio'

# Shortcuts for pin values
LOW = 0
HIGH = 1

IN = 'in'
OUT = 'out'

# Exception to handle unknown pin mode (not 'in' or 'out')
class UnknownMode < StandardError
end

class NotOutMode < StandardError
end

# Exception to handle bad pin value (not 0 or 1)
class BadValue < StandardError
end

# GPIO class
class GPIO

  # Initialize the GPIO pin
  #
  # @param pin [Integer] GPIO pin to use
  # @param mode [String, nil] pin mode ('in' or 'out')
  def initialize(pin, mode = OUT)
    @pin = pin
    begin
      File.open("#{LIB_PATH}/export", 'w') do |file|
        file.write(@pin)
      end
    rescue Errno::EBUSY
      # -
    end
    @mode = mode
  end

  # Set the pin mode
  #
  # @param mode [String] pin mode ('in' or 'out')
  def set_mode(mode)
    raise UnknownMode, "gpio error : unknown mode #{mode}" unless mode == IN or mode == OUT
    File.open("#{LIB_PATH}/gpio#{@pin}/direction", 'w') do |file|
      file.write(mode)
    end
    @mode = mode
  end

  # Read the value of the pin
  #
  # @return [Boolean]
  def get_value
    File.open("#{LIB_PATH}/gpio#{@pin}/value", 'r').read
  end

  # Set a value to the pin
  #
  # @param v [Integer] the value (0 or 1)
  def set_value(v)
    raise NotOutMode, "error : mode isn't OUT" unless @mode == OUT
    raise BadValue, "error : bad pin value" unless v.between? 0,1
    File.open("#{LIB_PATH}/gpio#{@pin}/value", 'w') do |file|
      file.write(v)
    end
  end
end