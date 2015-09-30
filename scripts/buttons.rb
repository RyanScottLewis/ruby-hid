require_relative '../lib/ruby_hid.rb'
puts RubyHid::Device.list()

if ARGV[0]
  name = RubyHid::Device.list(ARGV[0].to_s)[0]
else
  name = RubyHid::Device.list('USB_Joystick')[0]
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
