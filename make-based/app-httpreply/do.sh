#!/bin/bash

QEMU_PATH=${1:-$(which qemu-system-x86_64)}

app_basename="httpreply"
app_libs="lwip"
use_networking=1
use_kvm="0"

source ../include/do_base
