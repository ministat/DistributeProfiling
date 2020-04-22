#!/bin/bash
if [ $# -ne 1 ]; then
   echo "$0: <node_list_file>"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  ssh ${i} 'bash -c "[ ! -d profiling ] && mkdir -p profiling"'
  scp cpu_profile.sh lock_profile.sh do_profile_when_load_high.sh ${i}:~/profiling
done
