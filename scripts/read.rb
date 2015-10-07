require_relative '../lib/ruby_hid.rb'

if ARGV[0]
  name = RubyHid::Device.list(ARGV[0].to_s)[0]
else
  name = RubyHid::Device.list[0]
end

dev = RubyHid::Device.new(name, 24)
dev.each do |event|
  puts event
end
