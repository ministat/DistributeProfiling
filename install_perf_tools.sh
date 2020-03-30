#!/bin/bash
async=../async-profiler-1.7-linux-x64.tar.gz
perf=../perf-map-agent.tgz
for i in `cat node_perf.txt`
do
  scp $async $perf ${i}:~/
  ssh ${i} 'tar zxvf perf-map-agent.tgz'
  ssh ${i} 'mkdir -p async-profiler-1.7; cd async-profiler-1.7; tar zxvf ../async-profiler-1.7-linux-x64.tar.gz'
done
