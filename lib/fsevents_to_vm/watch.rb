require 'rb-fsevent'

module FseventsToVm
  class Watch
    def initialize(*listen_dirs)
      @listen_dirs = listen_dirs
      @fs = FSEvent.new
    end

    def run
      @fs.watch(@listen_dirs, file_events: true) do |_, raw_events|
        raw_events['events'].each do |raw_event|
          event = build_event(raw_event)
          yield event if event
        end
      end
      @fs.run
    end

    private

    def build_event(raw_event)
      filepath = raw_event['path']
      event_type = raw_event['flags'].include?('ItemModified') ? :modified : :attrib
      mtime = Event.format_time(File.stat(filepath).mtime)
      Event.new(filepath, event_type, mtime, Time.now)
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