require 'ostruct'
require_relative './ruby_hid/device.rb'
require_relative './ruby_hid/observer.rb'
require_relative './ruby_hid/button.rb'
require_relative './ruby_hid/axis.rb'
require_relative './ruby_hid/store.rb'

RubyHid::Axis.build
RubyHid::Button.build
