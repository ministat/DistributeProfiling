#!/bin/bash
if [ $# -ne 1 ];then
   echo "Specify <node_list>"
   exit 1
fi

node_list=$1
tgt_dir=profiling
for i in `cat $node_list`
do
  ssh ${i} 'rm $tgt_dir/cpu/*'
  ssh ${i} 'rm $tgt_dir/lock/*'
done
