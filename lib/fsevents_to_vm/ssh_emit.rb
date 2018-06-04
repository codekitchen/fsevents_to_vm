module FseventsToVm
  class SshEmit
    def initialize(ssh_exec)
      @ssh_exec = ssh_exec
    end

    def emit!(event)
      command =
        "gtouch -m -c -d #{event.mtime} #{Shellwords.escape event.path}".
        force_encoding(Encoding::BINARY)

      @ssh_exec.exec!(command)
    end
  end
end
