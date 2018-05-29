require 'fsevents_to_vm/ssh_exec'

module FseventsToVm
  class SshEmit < SshExec
    def emit!(event)
      exec!(
        command:
          "gtouch -m -c -d #{event.mtime} #{Shellwords.escape event.path}".
          force_encoding(Encoding::BINARY),
        description:
          "sending event: #{event.inspect}"
      )
    end
  end
end
