ruby-hid
==========

A ruby library for observing HID game controllers. Currently supports

* Ubuntu Linux

Currently this only handles one controller at a time.

*Warning:* ruby_hid has to change some rights down in the /sys and /dev
folders of Linux in order to access the kernel. You will be asked for
your password in order to use ruby_hid.

Example Scripts
===============

devices.rb
----------

```bash
$ ruby scripts/devices.rb
```

This lists the devices known to ruby_hid. e.g.:

```bash
$ ruby scripts/devices.rb
/dev/input/by-id/usb-Saitek_ST200_Stick-event-joystick
/dev/input/by-id/usb-MY-POWER_CO._LTD._2In1_USB_Joystick-event-joystick
```

All of the other example scripts take part the device names as
an argument. For instance:

```bash
$ ruby scripts/read.rb Saitek
$ ruby scripts/read.rb MY-POWER
```

But they can all be called without an argument, in
this case they'll use the first one on the list.

-----------------------

read.rb
-------

```bash
$ ruby scripts/read.rb 
```

This outputs the raw information from each event sent
by the controller. e.g.:

```bash
$ ruby scripts/read.rb 
2015-10-07T20:01:03+01:00 type: 1 code: 288 value: 1
2015-10-07T20:01:03+01:00 type: 1 code: 288 value: 0
2015-10-07T20:01:04+01:00 type: 1 code: 289 value: 1
2015-10-07T20:01:04+01:00 type: 1 code: 289 value: 0
2015-10-07T20:01:05+01:00 type: 3 code: 16 value: -1
2015-10-07T20:01:05+01:00 type: 3 code: 16 value: 0
2015-10-07T20:01:07+01:00 type: 3 code: 1 value: 99
2015-10-07T20:01:07+01:00 type: 3 code: 1 value: 85
2015-10-07T20:01:07+01:00 type: 3 code: 1 value: 73
2015-10-07T20:01:07+01:00 type: 3 code: 1 value: 61
```

buttons.rb
----------

```bash
$ ruby scripts/buttons.rb 
```

This reads the button-type events, outputting them as
names and values. e.g.:

```bash
$ ruby scripts/buttons.rb 
btn_1 pushed: 1
btn_1 pushed: 0
l1 pushed: 1
l1 pushed: 0
select pushed: 1
select pushed: 0
```

axes.rb
----------

```bash
$ ruby scripts/axes.rb 
```

This reads the axis-type events, outputting them as
names and values. e.g.:

```bash
$ ruby scripts/axes.rb 
left_x changed: 125
left_x changed: 110
left_x changed: 101
left_x changed: 90
left_x changed: 74
left_x changed: 56
left_x changed: 38
left_x changed: 20
left_x changed: 1
left_x changed: 0
left_x changed: 10
left_x changed: 128
```

move_cursor.rb
--------------

A very simple movement script with ASCII output.
It reads the left hand stick of a joypad.

```bash
$ ruby scripts/axes.rb 
+----------------------------------------+
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
|              #                         |
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
|                                        |
+----------------------------------------+
x: 14   - y: 8
```

Using it in your code
=====================

Button Events
-------------

Include the ruby_hid library

`require 'ruby_hid'`

Buttons are binary controls, events on button changes can
have one of two values:

* 1 - button down
* 0 - button up

You can find buttons with the RubyHid::Button class. Find
the names or codeds in the EVENTS hash.

```ruby
RubyHid::Button.find(297)
RubyHid::Button.find_by_name(:l1)
```

And define an event to be run 

```ruby
button = RubyHid::Button.find_by_name(:l1)
button.add_event(
  lambda {|value|
    if value == 1
      puts "You pushed L1"
    else
      puts "Lou released L1"
    end 
  }
)
```

You can debug the actions you've added to a button with trigger_events

```ruby
# test button down event
button.trigger_events(1)
# test button up event
button.trigger_events(0)
```

How about getting it to run when you press the button?

The RubyHid::Device class is responsible for reading the raw input
from the Buzz controllers via the linux terminal. Because it's reading
a data stream, it needs to start a background process to allow it to 
work while other ruby code is operating.

You can start background process, which executes the events you added
to the buttons, with start_watching.

```ruby
device = RubyHid::Device.new

button = RubyHid::Button.find_by_name(:l1)
button.add_event(
  lambda {|value|
    if value == 1
      puts "You pushed L1"
    else
      puts "You released L1"
    end 
  }
)

device.start_watching
```

Note: This process will end when your ruby process ends, but if you
want to stop it before that stage, you can call `device.stop_watching`

If you want to do nothing other than watch the buttons, you may want
to follow start_watching with an empty loop in order to keep your
ruby process, and the the forked process which watches the controller
alive. 

```ruby
device = RubyHid::Device.new(RubyHid::Device.list[0])

button = RubyHid::Button.find_by_name(:l1)
button.add_event(
  lambda {|value|
    if value == 1
      puts "You pushed L1"
    else
      puts "You released L1"
    end 
  }
)

device.start_watching20

loop do
  sleep 1
end 
```

Axis Events
-----------

Axes are continuous control events coming from a controller. Usually
these are joysticks or throttles. 

They differ from buttons in that they have a wider range of values,
often the event is triggered a large number of times as the event is 
triggered.
 
They work in the same ways as buttons, only they are accessed via the 
RubyHid::Axis class.

*Note:* as the observers work on a separate process, and because axes 
send a large number of messages it is wise to keep the events on your
axes as small as possible, and modify a shared object.
  
```ruby
require 'ostruct'
require_relative '../lib/ruby_hid.rb'

@cursor = OpenStruct.new(
  :x => 50.0, :y => 50.0,
  :x_speed => 0, :y_speed => 0
)

axis = RubyHid::Axis.find_by_name(:left_y)
axis.add_event(
  lambda do |value|
    # value / 255 is from 0 to 1
    @cursor.y_speed = ((value.to_f / 255.0) - 0.5)
  end
)

axis = RubyHid::Axis.find_by_name(:left_x)
axis.add_event(
  lambda do |value|
    # value / 255 is from 0 to 1
    @cursor.x_speed = ((value.to_f / 255.0) - 0.5)
  end
)

device = RubyHid::Device.new(RubyHid::Device.list[0])
device.start_watching

loop do
  # Observers have set x_speed and y_speed
  # each step increments both dimensions by it's own speed
  @cursor.x += @cursor.x_speed
  @cursor.y += @cursor.y_speed

  puts "x: #{@cursor.x.to_i.to_s.ljust(4)} - y: #{@cursor.y.to_i}"
  sleep 0.1
end
``` 
 

Acknowledgements
===============

This repo includes a modified version of the devinput class from
https://github.com/kamaradclimber/libdevinput
which was forked from
https://github.com/prullmann/libdevinput

Without that clone of libdev, written in ruby, I would not have been
able to 