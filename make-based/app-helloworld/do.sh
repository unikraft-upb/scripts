#!/bin/bash

QEMU_PATH=${1:-$(which qemu-system-x86_64)}

app_basename="helloworld"
use_kvm=0

source ../include/do_base
