require 'net/ssh'
require 'shellwords'
require 'tempfile'

module FseventsToVm
  class SshEmit
    def initialize(identity_file, ip, username)
      @identity_file = identity_file
      @ip = ip
      @username = username
    end

    def event(event)
      ssh.exec!("gtouch -m -c -d #{event.mtime} #{Shellwords.escape event.path}".force_encoding(Encoding::BINARY))
    rescue IOError, SystemCallError, Net::SSH::Exception => e
      $stderr.puts "Error sending event: #{e.class}: #{e}"
      $stderr.puts "\t#{e.backtrace.join("\n\t")}"
      disconnect!
    end

    protected

    def ssh
      @ssh ||= Net::SSH.start(@ip, @username,
        config: false,
        keys: [@identity_file],
        keys_only: true,
        paranoid: false)
    end

    def disconnect!
      @ssh = nil
    end
  end
end
