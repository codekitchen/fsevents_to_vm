# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fsevents_to_vm/version'

Gem::Specification.new do |spec|
  spec.name          = "fsevents_to_vm"
  spec.version       = FseventsToVm::VERSION
  spec.authors       = ["Brian Palmer"]
  spec.email         = ["brian@codekitchen.net"]

  spec.summary       = %q{forward OS X file system events to a VM, designed for use with Dinghy}
  spec.homepage      = "https://github.com/codekitchen/fsevents_to_vm"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rb-fsevent", "~> 0.9.5"
  spec.add_dependency "rb-inotify", "~> 0.9.5"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "net-ssh", "~> 2.9.2"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
