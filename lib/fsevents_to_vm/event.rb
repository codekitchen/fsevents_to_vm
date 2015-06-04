module FseventsToVm
  class Event < Struct.new(:path, :mtime)
    def self.format_time(time)
      time.utc.strftime("%Y%m%d%H%M.%S")
    end
  end
end
