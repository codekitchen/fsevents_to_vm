module FseventsToVm
  class SshInstallGnuTouch
    CHECK_COMMAND = 'gtouch --version | grep "GNU coreutils"'

    CHECK_COMMAND_SUCCEEDED = /touch \(GNU coreutils\) 8\./

    INSTALL_COMMAND =
      'CONTAINER_ID=$(docker create codekitchen/dinghy-http-proxy:2.5) '\
      '&& sudo docker cp -L ${CONTAINER_ID}:/bin/touch /bin/gtouch ' \
      '&& docker rm ${CONTAINER_ID} && echo "Installed GNU touch"'

    INSTALL_COMMAND_SUCCEEDED = /Installed GNU touch/

    def initialize(ssh_exec, debug = false)
      @ssh_exec = ssh_exec
      @debug = debug
    end

    def install!
      return if check_installed?

      puts 'Installing GNU touch from a container into the VM...' if @debug

      output = @ssh_exec.exec!(INSTALL_COMMAND)
      success = INSTALL_COMMAND_SUCCEEDED =~ output

      if @debug
        puts "+ #{INSTALL_COMMAND}"
        puts output
        puts 'Installed successfully.' if success
      end

      raise "Failed to install GNU touch into VM: #{output}" unless success

      output
    end

    def check_installed?
      puts 'Checking if GNU touch already installed in the VM...' if @debug
      output = @ssh_exec.exec!(CHECK_COMMAND)
      success = CHECK_COMMAND_SUCCEEDED =~ output

      if @debug
        puts "+ #{CHECK_COMMAND}"
        puts output
        if success
          puts 'Already installed.'
        else
          puts 'Not installed.'
        end
      end

      success
    end
  end
end
