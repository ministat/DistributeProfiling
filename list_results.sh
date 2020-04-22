#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify <node_list>"
   exit 1
fi

nodeList=$1
for i in `cat $nodeList`
do
   echo "======${i}======"
   ssh ${i} 'ls -lt profiling/cpu'
   ssh ${i} 'ls -lt profiling/lock'
done
