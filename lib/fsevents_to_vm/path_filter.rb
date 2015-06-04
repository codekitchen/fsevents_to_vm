module FseventsToVm
  class PathFilter
    def initialize
      @filter = %r{#{ENV['HOME']}/(Library|\.)}
    end

    def ignore?(event)
      !!@filter.match(event.path)
    end
  end
end
