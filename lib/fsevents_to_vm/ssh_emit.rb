require 'net/ssh'
require 'shellwords'
require 'tempfile'

module FseventsToVm
  class SshEmit
    def initialize(ssh_config_file)
      @ssh = Net::SSH.start('dinghy', 'docker', config: ssh_config_file.path)
    end

    def event(event)
      @ssh.exec!("touch -m -c -t #{event.mtime} #{Shellwords.escape event.path}".force_encoding(Encoding::BINARY))
    end
  end
end
