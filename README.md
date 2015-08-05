# FSEvents To VM

Forward OS X file system events to a VM, designed for use with Dinghy.

# Installation

Normally you won't install this manually, Dinghy will do it for you.

If you want to manually install:

    $ gem install fsevents_to_vm

## Usage

Dinghy will start fsevents_to_vm automatically. If you would like to run in manually:

The Dinghy VM must be running. Then in a terminal run:

    $ fsevents_to_vm start

You can specify a specific directory to watch. This directory must be already mounted in the VM over NFS. By default, this means anything in your home dir:

    $ fsevents_to_vm start ~/projects

## Known Limitations

* Delete events are not forwarded.
* Multiple events for the same file within the same 1/100th of a second may cause events to be missed.
* Some directories that you are unlikely to care about are ignored, for example `~/Library`.
