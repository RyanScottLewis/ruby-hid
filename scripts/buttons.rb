require_relative '../lib/ruby_hid.rb'

name = '/dev/input/by-id/usb-DragonRise_Inc._Generic_USB_Joystick-event-joystick'

RubyHid::Button.build

buttons = RubyHid::Button::BUTTONS

buttons.each do |code, name|
  button = RubyHid::Button.find_by_name(name)
  button.add_event(
    eval "lambda { |val| puts \"#{name} pushed: \#{val}\" }"
  )
end

dev = RubyHid::Device.new(name)
dev.start_watching

loop do
  sleep 1
end
