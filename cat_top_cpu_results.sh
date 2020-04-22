#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify <node_list>"
   exit 1
fi

node_list=$1
tgt_dir=profiling
for i in `cat $node_list`
do
  a=`ssh ${i} "ls $tgt_dir/cpu/"`
  for j in $a
  do
    s=`ssh ${i} "cat $tgt_dir/cpu/$j"|grep "^Total samples"|awk '{if ($4 == 0) print "skip"}'`
    if [ "$s" != "skip" ]; then
      ssh ${i} "cat $tgt_dir/cpu/$j"| awk '{if ($0 ~ /---/) s++; if (s <= 2) print $0}'
    fi
  done
done
