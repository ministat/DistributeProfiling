#!/bin/bash
if [ $# -ne 2 ]; then
   echo "$0: <top_num> <executor_list_result>"
   exit 1
fi

top_num=$1
executor_list=$2

sh exclude_p3g6.sh $executor_list|head -n $top_num|tr -d '='
