require_relative '../lib/ruby_hid.rb'

if ARGV[0]
  name = RubyHid::Device.list(ARGV[0].to_s)[0]
else
  name = RubyHid::Device.list()[0]
end

dev = RubyHid::Device.new(name)

axes = RubyHid::Axis::EVENTS

axes.each do |code, name|
  axis = RubyHid::Axis.find_by_name(name)
  axis.add_event(
    eval "lambda { |val| puts \"#{name} changed: \#{val}\" }"
  )
end

axis = RubyHid::Axis.find(1)

dev.start_watching

loop do
  sleep 1
end
