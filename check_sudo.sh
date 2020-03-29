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
   a=`ssh -o StrictHostKeyChecking=no $i 'sudo -v 2> /dev/null && echo true' 2>/dev/null`
   if [ "$a" != "" ];then
      echo $i
   fi
done
