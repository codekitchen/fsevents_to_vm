module FseventsToVm
  module SshConfig
    def self.fetch(ssh_config_file)
      if ssh_config_file
        File.open(ssh_config_file, 'rb')
      else
        ssh_config = `dinghy ssh-config`
        raise("Could not read Vagrant VM ssh config") unless $?.success?
        file = Tempfile.new('fsevents-ssh-config')
        file.write(ssh_config)
        file.flush
        file
      end
    end
  end
end
