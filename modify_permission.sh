#!/bin/bash
if [ $# -ne 1 ];
then
  echo "$0: <node_list>"
  exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  ssh ${i} 'sudo echo -1 > /proc/sys/kernel/perf_event_paranoid'
done
