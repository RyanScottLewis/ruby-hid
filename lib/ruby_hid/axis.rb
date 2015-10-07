module RubyHid

  #
  # An axis is a continuous control coming from a HID device.
  # These are most often the output from joysticks.
  #
  # The most common values for axes range from 0 to 255.
  # In this case the central (resting) position is 128.
  #
  # Axis includes d-pad axes, which have a distinctly
  # different set of values.
  #
  # * -1 up or left
  # * 0 centre
  # * 1 down or right
  #
  class Axis < RubyHid::Observer

    #
    # List of Axes, with names
    #
    # Naming is mostly the stick name followed
    # by x or y for the direction.
    #
    EVENTS = {
      0 => :left_x,
      1 => :left_y,
      2 => :right_x,
      5 => :right_y,
      6 => :throttle,
      16 => :dpad_x,
      17 => :dpad_y
    }

    #
    # Quick summary of the button
    #
    def to_s
      "Axis: #{code} - #{name}"
    end

  end

end