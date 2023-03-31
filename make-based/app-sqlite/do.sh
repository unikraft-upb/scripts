#!/bin/bash

app_basename="sqlite"
app_libs="musl sqlite"
use_kvm="1"
use_9p_rootfs="1"
rootfs_9p="$PWD"/rootfs

source ../include/do_base
