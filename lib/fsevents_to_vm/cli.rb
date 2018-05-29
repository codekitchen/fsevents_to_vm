require 'thor'
require 'fsevents_to_vm'

module FseventsToVm
  class Cli < Thor
    option :debug, type: :boolean, default: false
    option :ssh_identity_file, type: :string
    option :ssh_ip, type: :string
    option :ssh_username, type: :string, default: 'docker'

    desc "start PATH",
         "Watch PATH and forward filesystem touch events to the Dinghy VM."
    def start(listen_dir = ENV['HOME'])
      debug = options[:debug]

      FseventsToVm::DinghyInstallGnuTouch.new(debug).run

      watcher = FseventsToVm::Watch.new(listen_dir)
      path_filter = FseventsToVm::PathFilter.new
      recursion_filter = FseventsToVm::RecursionFilter.new
      forwarder = FseventsToVm::SshEmit.new(options[:ssh_identity_file], options[:ssh_ip], options[:ssh_username])

      if debug
        puts "Watching #{listen_dir} and forwarding events to Dinghy VM..."
      end

      watcher.run do |event|
        next if path_filter.ignore?(event)
        next if recursion_filter.ignore?(event)
        if debug
          puts "touching #{event.mtime}:#{event.path}"
        end
        forwarder.emit!(event)
      end
    end
  end
end
