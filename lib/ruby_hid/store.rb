module RubyHid

  class Store < OpenStruct

    attr_accessor :device

    def initialize
      super
      init_observers
      init_device
    end

    def init_device
      if device.nil?
        self.device = Device.new(
          RubyHid::Device.list[0]
        )
      end
      device.start_watching
    end

    def init_observers
      events = Axis::EVENTS.values + Button::EVENTS.values
      store = self
      events.each do |name|
        send("#{name}=", 0)
        control = Axis.find_by_name(name)
        control ||= Button.find_by_name(name)
        control.add_event(
          lambda {|val| store.send("#{name}=", val)}
        )
      end
    end

  end

end
