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

    def exec!(command:, description: nil)
      raise ArgumentError, "required command" if command.nil? || command.empty?
      result = ssh.exec!(command)
      raise(SshCommandError, result) if !result.nil? && !result.empty?
    rescue IOError, SystemCallError, Net::SSH::Exception, SshCommandError => e
      $stderr.puts "Error #{description || "running command `#{command}`"}"
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
      @ssh = nil
    end

    class SshCommandError < StandardError
    end
  end
end
