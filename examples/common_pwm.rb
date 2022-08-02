require_relative '../lib/raspi-pwm.rb'

pwm = RaspiPWM.new(channel: 0)
pwm.frequency = 2
pwm.duty_cycle = 50
pwm.enabled = true
sleep(10)
pwm.enabled = false
pwm.cleanup
