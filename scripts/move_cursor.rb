require 'ostruct'
require_relative '../lib/ruby_hid.rb'

class Cursor < OpenStruct

  def draw
    puts `clear`
    out = "+#{'-'*max_x}+\n"

    max_y.times do |row|
       out << '|'
      max_x.times do |column|
        if y.to_i == row and x.to_i == column
          out << '#'
        else
          out << ' '
        end
      end
      out << "|\n"
    end

    out << "+#{'-'*max_x}+\n"
    puts out
  end

end

@cursor = Cursor.new(
  :speed => 2,
  :x => 5.0, :x_speed => 0.0,
  :y => 5.0, :y_speed => 0.0,
  :max_x => 40, :max_y => 15
)

axis = RubyHid::Axis.find_by_name(:left_y)
axis.add_event(
  lambda do |value|
    @cursor.y_speed = ((value.to_f / 255.0) - 0.5) * @cursor.speed
  end
)

axis = RubyHid::Axis.find_by_name(:left_x)
axis.add_event(
  lambda do |value|
    @cursor.x_speed = ((value.to_f / 255.0) - 0.5) * @cursor.speed
  end
)

device = RubyHid::Device.new(RubyHid::Device.list[0])
device.start_watching

loop do
  if (@cursor.x >= 0 and @cursor.x_speed < 0) or
    (@cursor.x <= (@cursor.max_x - 1) and @cursor.x_speed > 0)
    @cursor.x += @cursor.x_speed
  end
  if (@cursor.y >= 0 and @cursor.y_speed < 0) or
    (@cursor.y <= (@cursor.max_y - 1) and @cursor.y_speed > 0)
    @cursor.y += @cursor.y_speed
  end

  @cursor.draw
  puts "x: #{@cursor.x.to_i.to_s.ljust(4)} - y: #{@cursor.y.to_i}"
  sleep 0.1
end