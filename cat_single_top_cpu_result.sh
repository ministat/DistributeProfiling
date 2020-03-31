#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify <node>"
   exit 1
fi

node=$1

a=`ssh ${node} "ls async-profiler-1.7/cpu/"`
for j in $a
do
  s=`ssh ${node} "cat async-profiler-1.7/cpu/$j"|grep "^Total samples"|awk '{if ($4 == 0) print "skip"}'`
  if [ "$s" != "skip" ]; then
    ssh ${node} "cat async-profiler-1.7/cpu/$j"| awk '{if ($0 ~ /---/) s++; if (s <= 2) print $0}'
  fi
done
