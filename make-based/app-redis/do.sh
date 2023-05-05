#!/bin/bash

app_basename="redis"
app_libs="redis musl lwip"
use_networking=1
use_kvm="0"
use_9p_rootfs=1
rootfs_9p="fs0"
extra_app_arguments="/redis.conf"

source ../include/do_base
