require 'net/ssh'
require 'shellwords'
require 'tempfile'

module FseventsToVm
  class SshEmit
    def initialize
      @ssh_config = Tempfile.new('fsevents-ssh-config')
      @ssh_config.write(`cd /usr/local/var/dinghy/vagrant && vagrant ssh-config --host dinghy`)
      raise("Could not read Vagrant VM ssh config") unless $?.success?
      @ssh_config.flush
      @ssh = Net::SSH.start('dinghy', 'docker', config: @ssh_config.path)
    end

    def event(event)
      @ssh.exec!("touch -m -t #{event.mtime} #{Shellwords.escape event.path}")
    end
  end
end
