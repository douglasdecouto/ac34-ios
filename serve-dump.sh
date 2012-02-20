#!/bin/sh

# ./serve-dump.sh <dump-file>

# while true; do python replay.py --speed 0 < $1 | nc  -l 4941  ; done
# while true; do nc  -l 4941 < $1  ; done

while true; do python replay.py --speed 0 --verbose -f $1 | nc  -l 4941  ; done