require 'time'

module FseventsToVm
  # path: String
  # mtime: String
  # event_time: Time
  class Event < Struct.new(:path, :mtime, :event_time)
    def self.format_time(time)
      # Format with nanosecond precision for Linux `touch -d`, see:
      # https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html#touch-invocation
      time.utc.iso8601(9)
    end
  end
end
