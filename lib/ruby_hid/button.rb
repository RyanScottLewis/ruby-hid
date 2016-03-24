module RubyHid

  #
  # Button objects are observers of buttons on a controller.
  # Buttons which are currently available are listed, by name
  # in the EVENTS constant.
  #
  # Buttons can have 2 values passed to each event:
  #
  # * 1 - button down event
  # * 0 - button up event
  #
  # To set the actions for a button use add_event:
  #
  #   button = Button.find_by_name(:btn_1)
  #   button.add_event(lambda{ |value| puts "Button 1: #{value}" })
  #
  #
  class Button < RubyHid::Observer

    #
    # List of button types, with names
    #
    EVENTS = {
      # joy pads
      288 => :btn_1,
      289 => :btn_2,
      290 => :btn_3,
      291 => :btn_4,
      292 => :l1,
      293 => :r1,
      294 => :l2,
      295 => :r2,
      296 => :select,
      297 => :start,
      298 => :l_stick,
      299 => :r_stick
    }

    #
    # Quick summary of the button
    #
    def to_s
      "Button: #{code} - #{name}"
    end

  end

end
