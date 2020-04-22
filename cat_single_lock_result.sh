#!/bin/bash
if [ $# -ne 2 ]; then
   echo "Specify <node> <file>"
   exit 1
fi

node=$1
file=$2

ssh ${node} "cat profiling/lock/$file" | awk '{if ($0 ~ /---/) s++; if (s <= 2) print $0}'
