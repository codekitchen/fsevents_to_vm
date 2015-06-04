require 'thor'
require 'fsevents_to_vm'

module FseventsToVm
  class Cli < Thor
    option :debug, type: :boolean, default: true
    desc "start PATH",
      "Watch PATH and forward filesystem touch events to the Dinghy VM."
    def start(listen_dir = ENV['HOME'])
      debug = options[:debug]

      watcher = FseventsToVm::Watch.new(listen_dir)
      path_filter = FseventsToVm::PathFilter.new
      recursion_filter = FseventsToVm::RecursionFilter.new
      forwarder = FseventsToVm::SshEmit.new

      if debug
        puts "Watching #{listen_dir} and forwarding events to Dinghy VM..."
      end

      watcher.run do |event|
        next if path_filter.ignore?(event)
        next if recursion_filter.ignore?(event)
        if debug
          puts "touching #{event.mtime}:#{event.path}"
        end
        forwarder.event(event)
      end
    end
  end
end
