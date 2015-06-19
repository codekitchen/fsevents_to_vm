module FseventsToVm
  class PathFilter
    def initialize
      @filter = %r{#{ENV['HOME']}/(Library|\.)|/\.(git|hg|svn)/}
    end

    def ignore?(event)
      !!@filter.match(event.path)
    end
  end
end
