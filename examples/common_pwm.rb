require_relative '../lib/raspi-pwm.rb'

pwm = RaspiPWM.new(channel: 0)
# to give for the system some time for creating
# needed files and setting appropriate permissions
sleep(0.5)
pwm.frequency = 2
pwm.duty_cycle = 50
pwm.enabled = true
sleep(10)
pwm.enabled = false
pwm.cleanup
