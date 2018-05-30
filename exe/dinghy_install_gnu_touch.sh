#!/bin/bash
##
# Extract the 'touch' binary from the 'dinghy-http-proxy' Docker container,
# and install it as '/bin/gtouch' inside the Dinghy boot2docker VM.
#
# This binary is compatible with the VM's BusyBox image, and provides
# a touch binary that supports nanosecond timestamps.
##
set -ex

# In order to copy from a Docker container to a host temporary
# directory, it must be under the directory tree exported via Dinghy's
# NFS server into the VM.
HOST_NFS_DIR="${DINGHY_HOST_MOUNT_DIR:-${HOME}}"
mkdir -pv "${HOST_NFS_DIR}/tmp"
HOST_TMP_DIR=$(mktemp -d "${HOST_NFS_DIR}/tmp/dinghy_tmp.XXXXXXXX")

# Copy 'touch' from a Linux Docker container to the host
CONTAINER_ID=$(docker create codekitchen/dinghy-http-proxy:2.5)
docker cp ${CONTAINER_ID}:/bin/touch ${HOST_TMP_DIR}/touch
docker rm ${CONTAINER_ID}

# Copy 'touch' from host to the Dinghy VM as 'gtouch'
dinghy ssh sudo cp ${HOST_TMP_DIR}/touch /bin/gtouch

# Cleanup host temporary directory
rm ${HOST_TMP_DIR}/touch && rmdir ${HOST_TMP_DIR}

# Verify we can now call 'gtouch' in Dinghy VM
dinghy ssh gtouch --version | grep "GNU coreutils" \
    || echo "Failed to install 'touch' from ubuntu 16.04 into Dinghy's VM"
