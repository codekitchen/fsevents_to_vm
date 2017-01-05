require 'rb-fsevent'

module FseventsToVm
  class Watch
    def initialize(*listen_dirs)
      @listen_dirs = listen_dirs
      @fs = FSEvent.new
    end

    def run
      @fs.watch(@listen_dirs, file_events: true) do |files|
        files.each do |file|
          event = build_event(file)
          yield event if event
        end
      end
      @fs.run
    end

    private

    def build_event(filepath)
      mtime = Event.format_time(File.stat(filepath).mtime)
      Event.new(filepath, mtime, Time.now)
    rescue Errno::ENOENT
      # TODO: handling delete events is tricky due to race conditions with rapid
      # delete/create.
      nil
    rescue Errno::ENOTDIR
      # dir structure changed
      nil
    end
  end
end
