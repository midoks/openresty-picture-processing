#!/bin/bash

[ -e tclip ] && rm -rf tclip
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig
g++  tclip.cpp `pkg-config opencv --libs --cflags opencv` -o tclip
