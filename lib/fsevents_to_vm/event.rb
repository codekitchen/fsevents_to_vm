module FseventsToVm
  # path: String
  # event_type: symbol
  # mtime: Time
  # event_time: Time
  Event = Struct.new(:path, :event_type, :mtime, :event_time) do
    EVENT_TYPES = [:modified, :attrib]

    def initialize(*a, &b)
      super(*a, &b)
      raise(ArgumentError, "invalid event type: #{self.event_type}") unless EVENT_TYPES.include?(self.event_type)
    end

    def self.format_time(time)
      time.utc.strftime("%Y%m%d%H%M.%S")
    end
  end
end