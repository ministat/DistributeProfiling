#!/bin/bash
if [ $# -ne 1 ]; then
   echo "specify node_list"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  scp cpu_profile.sh lock_profile.sh do_profile_when_load_high.sh ${i}:~/async-profiler-1.7
  #nohup ssh ${i} 'nohup sh install_perf.sh &' &
done
