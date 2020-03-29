#!/bin/bash
for i in `cat node_sudo.txt`
do
  scp install_perf.sh ${i}:~/
  #nohup ssh ${i} 'nohup sh install_perf.sh &' &
done
