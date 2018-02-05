#!/bin/bash

[ -e tclip ] && rm -rf tclip
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig/:/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
g++  tclip.cpp `pkg-config opencv --libs --cflags opencv` -o tclip
