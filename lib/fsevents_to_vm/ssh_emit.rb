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
      ssh.exec!("touch -m -c -t #{event.mtime} #{Shellwords.escape event.path}".force_encoding(Encoding::BINARY))
    rescue SystemCallError => e
      $stderr.puts "Error sending event: #{e}"
      $stderr.puts "\t#{e.backtrace.join("\n\t")}"
      disconnect!
    end

    protected

    def ssh
      @ssh ||= Net::SSH.start(@ip, @username, config: false, keys: [@identity_file])
    end

    def disconnect!
      @ssh = nil
    end
  end
end
