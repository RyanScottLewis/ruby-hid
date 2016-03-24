module RubyHid

  class Store < OpenStruct

    attr_accessor :device

    def initialize
      super
      init_observers
      init_device
    end

    def normalise(key)
      value = @table[key]
      if value
        if Store.is_button?(key)
          value
        else # it's an axis
          range = Store.value_range(key)
          if range.respond_to?(:size)
            size = range.size
          else
            size = (range.max - range.min).abs + 1
          end
          (value - range.min).to_f / size
        end
      else
        0
      end
    end

    def normalised_hash
      @table.keys.inject({}) do |result, key|
        result[key] = normalise(key)
        result
      end
    end

    private

    def self.value_range(key)
      if Axis::DPAD_KEYS.include?(key)
        -1...1
      else
        0...255
      end
    end

    def self.is_button?(key)
      Button::EVENTS.values.include?(key)
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
          lambda { |val| store.send("#{name}=", val) }
        )
      end
    end

  end

end
