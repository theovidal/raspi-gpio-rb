require_relative '../lib/raspi-pwm.rb'

puts 'Initializing PWM #0 channel...'
pwm = RaspiPWM.new(channel: 0)
# to give for the system some time for creating
# needed files and setting appropriate permissions
sleep(0.5)
puts 'Setting PWM parameters'
pwm.frequency = 2
pwm.duty_cycle = 50
pwm.enabled = true
puts 'PWM was enabled! Letting it to run for the next 10 seconds...'
sleep(10)
puts 'Done'
pwm.cleanup
puts 'Everything was cleaned up! Good bye...'
