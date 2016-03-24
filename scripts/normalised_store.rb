require_relative '../lib/ruby_hid.rb'

store = RubyHid::Store.new

loop do
  print `clear`
  store.normalised_hash.each do |key, value|
    puts "#{key.to_s.ljust(10)}: #{value}"
  end
  # also store.normalise(:left_x) etc.
  sleep 0.1
end
