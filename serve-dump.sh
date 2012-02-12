#!/bin/sh

# ./serve-dump.sh <dump-file>

while true; do nc  -l 4941 < $1 ; done