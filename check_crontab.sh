#!/bin/bash

if [ $# -ne 1 ];
then
   echo "Specify the <node list>"
   exit 1
fi

nodeList=$1
for i in `cat $nodeList`
do
   check=`ssh ${i} 'crontab -l 2>&1 > /dev/null && echo installed'`
   if [ "$check" != "installed" ];then
      echo "not_installed: ${i}"
   fi
done
