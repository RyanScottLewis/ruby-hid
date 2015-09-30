require_relative '../lib/ruby_hid.rb'

if ARGV[0]
  name = RubyHid::Device.list(ARGV[0].to_s)[0]
else
  name = '/dev/input/by-id/usb-DragonRise_Inc._Generic_USB_Joystick-event-joystick'
end

dev = RubyHid::Device.new(name)


RubyHid::Button.build

buttons = RubyHid::Button::BUTTONS

buttons.each do |code, name|
  button = RubyHid::Button.find_by_name(name)
  button.add_event(
    eval "lambda { |val| puts \"#{name} pushed: \#{val}\" }"
  )
end

dev.start_watching

loop do
  sleep 1
end
