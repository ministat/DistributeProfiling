#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify <node_list>"
   exit 1
fi

nodeList=$1
for i in `cat $nodeList`
do
   echo "======${i}======"
   ssh ${i} 'sudo ls /home/hdfs/async-profiler-1.7/cpu'
   ssh ${i} 'sudo ls /home/hdfs/async-profiler-1.7/lock'
done
