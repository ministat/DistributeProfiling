#!/bin/bash
for i in `cat node_sudo.txt`
do
  #scp install_perf.sh ${i}:~/
  date > ${i}.log
  ssh ${i} 'sh install_perf.sh' 2>&1 >> ${i}.log &
done
