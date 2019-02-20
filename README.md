# raspi-gpio-rb

### 🔌 A simple and light interface to interact with GPIO pins of the Raspberry Pi.

Requires a Raspberry Pi with Raspbian installed on.

Library has been tested on models : 3B

## 🔧 Setup

Install the package with Ruby Gem :

```bash
gem install raspi-gpio
```

Then, include it in your project :

```ruby
require 'raspi-gpio'
```

## ⌨ Playing around

```ruby
# Defining our GPIO pin with pin number and mode (IN / OUT)
pin = GPIO.new 9, OUT

# Setting values
pin.set_value HIGH # Power
pin.set_value LOW  # No power

# Reading the value of a pin
pin.set_mode IN
puts pin.get_value # 1 or 0
```

## 🔬 Behind the library

This Ruby gem uses /sys/class/gpio interface to communicate with GPIO pins. It doesn't require super-user rights, so everyone on the OS can use it.
