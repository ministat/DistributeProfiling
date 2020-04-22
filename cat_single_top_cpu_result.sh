#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify <node>"
   exit 1
fi

node=$1
tgt_dir=profiling
a=`ssh ${node} "ls $tgt_dir/cpu/"`
for j in $a
do
  s=`ssh ${node} "cat $tgt_dir/cpu/$j"|grep "^Total samples"|awk '{if ($4 == 0) print "skip"}'`
  if [ "$s" != "skip" ]; then
    ssh ${node} "cat $tgt_dir/cpu/$j"| awk '{if ($0 ~ /---/) s++; if (s <= 2) print $0}'
  fi
done
