#!/bin/bash
if [ $# -ne 1 ];
then
   echo "Specify the <node list>"
   exit 1
fi

nodeList=$1
for i in `cat $nodeList`
do
   #echo $i
   a=`ssh -o StrictHostKeyChecking=no $i 'perf version > /dev/null|| echo false'`
   if [ "$a" != "" ];then
      echo "perf_not_installed: $i"
   fi
done
