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


Using it in your code
=====================

Button events
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
button.trigger_events(1)
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
to follow start_watching with an empty loop.

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

loop do
  sleep 1
end 
```

Acknowledgements
===============

This repo includes a modified version of the devinput class from
https://github.com/kamaradclimber/libdevinput
Which was forked from
https://github.com/prullmann/libdevinput

Without that clone of libdev, written in ruby, I would not have been
able to 