#!/bin/bash
if [ $# -ne 1 ];then
   echo "Specify <node_list>"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  ssh ${i} 'rm async-profiler-1.7/cpu/*'
  ssh ${i} 'rm async-profiler-1.7/lock/*'
done
