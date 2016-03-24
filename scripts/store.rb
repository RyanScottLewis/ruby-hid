require_relative '../lib/ruby_hid.rb'

store = RubyHid::Store.new

loop do
  puts store.to_h
  sleep 0.1
end
