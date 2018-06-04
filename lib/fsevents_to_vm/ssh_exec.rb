require 'net/ssh'
require 'shellwords'
require 'tempfile'

module FseventsToVm
  class SshExec
    def initialize(identity_file, ip, username)
      @identity_file = identity_file
      @ip = ip
      @username = username
    end

    def exec!(command)
      raise ArgumentError, "Missing command" if command.nil? || command.empty?
      ssh.exec!(command)
    rescue IOError, SystemCallError, Net::SSH::Exception => e
      $stderr.puts "Error running command `#{command}`"
      $stderr.puts "#{e.class}: #{e}"
      $stderr.puts "\t#{e.backtrace.join("\n\t")}"
      disconnect!
    end

    protected

    def ssh
      @ssh ||= Net::SSH.start(
        @ip,
        @username,
        config: false,
        keys: [@identity_file],
        keys_only: true,
        paranoid: false
      )
    end

    def disconnect!
      @ssh.close unless @ssh.nil? || @ssh.closed?
      @ssh = nil
    end
  end
end
