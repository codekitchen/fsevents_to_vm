def is_mac?
  RUBY_PLATFORM.downcase.include?("darwin")
end

def is_linux?
  RUBY_PLATFORM.downcase.include?("linux")
end

require 'rb-inotify' if is_linux?
require 'rb-fsevent' if is_mac?

module FseventsToVm
  class FsEventProxy

    attr_reader :notifier

    #
    # Accepts the ablosute_path which the notifier
    # will monitor
    #
    def initialize(absolute_path)
      @path = absolute_path
      @notifier = INotify::Notifier.new if is_linux?
      @notifier = FSEvent.new if is_mac?
    end

    #
    # Accepts a Proc object containing the code
    # to be executed when a notifier event occurs
    #
    def watch(&block)
      if is_mac?
        @notifier.watch([@path], file_events: true) do |event|
          block.call(event)
        end
      elsif is_linux?
        @notifier.watch(@path, :recursive, :attrib, :modify, :move, :create, :delete) do |event|
          block.call([event.absolute_name])
        end
      end
      puts "Watching #{@path}"
    end

    def run
      @notifier.run
    end

    def stop
      @notifier.stop
    end
  end
end
