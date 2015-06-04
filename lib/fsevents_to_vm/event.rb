module FseventsToVm
  # path: String
  # mtime: String
  # event_time: Time
  class Event < Struct.new(:path, :mtime, :event_time)
    def self.format_time(time)
      time.utc.strftime("%Y%m%d%H%M.%S")
    end
  end
end
