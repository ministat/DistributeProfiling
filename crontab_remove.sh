#!/bin/bash
if [ $# -ne 1 ];then
   echo "Specify the <node_list>"
   exit 1
fi

node_list=$1
for i in `cat $node_list`
do
  ssh ${i} 'crontab -l 2>/dev/null && crontab -r'
done
