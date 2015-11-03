require 'net/ssh'
require 'shellwords'
require 'tempfile'

module FseventsToVm
  class SshEmit
    def initialize(ssh_config_file)
      @config_path = ssh_config_file.path
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
      @ssh ||= Net::SSH.start('dinghy', 'docker', config: @config_path)
    end

    def disconnect!
      @ssh = nil
    end
  end
end
