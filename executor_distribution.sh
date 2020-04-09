#!/bin/bash

if [ $# -ne 1 ]; then
   echo "Specify the <node_list>"
   exit 1
fi

nodeList=$1
for i in `cat $nodeList`
do
   echo "======${i}======"
   ssh ${i} "/apache/java/bin/jps -m|grep 'CoarseGrainedExecutorBackend'|sort -k 4"|awk '{s[$4]++}END{for (i in s) print i "," s[i]}' | sort -t , -k 2 -n -r
done
