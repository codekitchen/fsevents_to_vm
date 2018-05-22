require 'open3'

module FseventsToVm
  class DinghyInstallGnuTouch
    INSTALL_SCRIPT =
      File.join(__dir__, '..', '..', 'exe', 'dinghy_install_gnu_touch.sh')

    CHECK_COMMAND = 'dinghy ssh gtouch --version'

    def initialize(debug = false)
      @debug = debug
    end

    def run
      return if already_installed?

      puts 'Installing GNU touch from Ubuntu into Dinghy VM...' if @debug

      begin
        output, status = without_bundler_env do
          Open3.capture2e(INSTALL_SCRIPT)
        end
      ensure
        puts output if !status.success? || @debug
        puts 'done.' if status.success? && @debug
      end
    end

    private

    def already_installed?
      puts 'Checking if GNU touch already installed in Dinghy VM...' if @debug

      output, status = without_bundler_env do
        puts "+ #{CHECK_COMMAND}" if @debug
        Open3.capture2e(CHECK_COMMAND)
      end

      puts output.lines.map { |line| "++ #{line}" }.join if @debug
      puts "Already installed." if status.success? && @debug
      puts "Not installed." if !status.success? && @debug

      status.success?
    end

    def without_bundler_env
      if defined?(Bundler)
        Bundler.with_clean_env { yield }
      else
        yield
      end
    end
  end
end
