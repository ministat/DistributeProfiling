#!/bin/bash
if [ $# -ne 1 ];then
   echo "Specify <node_list>"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  ssh ${i} 'bash -c "[ -d async-profiler-1.7 ] && rm -rf async-profiler-1.7"'
  ssh ${i} 'bash -c "[ -e async-profiler-1.7-linux-x64.tar.gz ] && rm async-profiler-1.7-linux-x64.tar.gz"'
  ssh ${i} 'bash -c "[ -e do_profile_when_load_high.sh ] && rm do_profile_when_load_high.sh"'
  ssh ${i} 'bash -c "[ -e install_perf.sh ] && rm install_perf.sh"'
done
