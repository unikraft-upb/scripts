#!/bin/bash

app_basename="micropython"
app_libs="lwip musl micropython"
use_networking=0
use_initrd=1
initrd="helloworld.py"
use_kvm="0"

source ../include/do_base
