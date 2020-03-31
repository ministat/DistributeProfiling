#!/bin/bash
if [ $# -ne 2 ]; then
   echo "Specify <node_list> <out_dir>"
   exit 1
fi

node_list=$1
out_dir=$2

if [ ! -e ${out_dir} ]; then
  mkdir ${out_dir}
fi

for i in `cat $node_list`
do
  scp -r ${i}:~/async-profiler-1.7/cpu ${out_dir}/${i}-cpu
done

