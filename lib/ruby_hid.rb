`sudo chmod 777 /sys/class/leds/*/brightness`
`sudo chmod 777 /dev/input/event*`

require_relative './ruby_hid/device.rb'
require_relative './ruby_hid/observer.rb'
require_relative './ruby_hid/button.rb'
require_relative './ruby_hid/axis.rb'

RubyHid::Axis.build
RubyHid::Button.build
