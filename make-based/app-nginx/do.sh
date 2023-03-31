#!/bin/bash

QEMU_PATH=${1:-$(which qemu-system-x86_64)}

app_basename="nginx"
app_libs="lwip musl nginx"
use_networking=1
use_9p_rootfs=1
rootfs_9p="fs0"
use_kvm="0"

source ../include/do_base
