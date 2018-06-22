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
      log_error("Error running command #{command.inspect}", e)
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
      begin
        @ssh.close unless @ssh.nil? || @ssh.closed?
      rescue => e
        log_error("Error closing the SSH connection", e)
      end
      @ssh = nil
    end

    def log_error(msg, e)
      $stderr.puts msg
      $stderr.puts "#{e.class}: #{e}"
      $stderr.puts "\t#{e.backtrace.join("\n\t")}"
    end
  end
end
