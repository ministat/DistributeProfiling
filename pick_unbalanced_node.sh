#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify the <executor_dist_result>"
   exit 1
fi

exec_dist=$1
