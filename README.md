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

## Testing

First, make sure that `fsevents` isn't already running due to `dinghy start`, kill it if necessary.

Then run manually:

    be ruby exe/fsevents_to_vm start --debug --ssh-identity-file ~/.docker/machine/machines/dinghy/id_rsa --ssh-ip $(dinghy ip) ~

You can use inotifywait in the VM to watch for events:

    docker run --rm -it -v $HOME:/fstest ubuntu:trusty
    apt-get update && apt-get install -y inotify-tools
    inotifywait /fstest/some/dir

Then modify a file in `~/some/dir` and watch for inotifywait to catch the change.
