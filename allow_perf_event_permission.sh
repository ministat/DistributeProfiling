#!/bin/bash
if [ $# -ne 1 ]; then
   echo "specify node_list"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  scp modify_perf_event_permission.sh ${i}:~/
  ssh -t ${i} 'sudo ./modify_perf_event_permission.sh'
done
