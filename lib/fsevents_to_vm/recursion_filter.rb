module FseventsToVm
  class RecursionFilter
    def initialize
      @recent_events = {}
    end

    def ignore?(event)
      if @recent_events[event.path] == event.mtime
        true
      else
        @recent_events[event.path] = event.mtime
        false
      end
    end

    private

    def purge_old_events!
      cutoff = Event.format_time(Time.now - 30)
      @recent_events.reject! { |path, mtime| mtime < cutoff }
    end
  end
end
