#!/bin/bash
if [ $# -ne 1 ]; then
   echo "$0: <profiling_dir>"
   exit 1
fi

tmpout=/tmp/k
grep soj $1/* -rn|awk '{print $3}'|grep "^com"|sort > $tmpout
awk '{a[$0]++}END{for (i in a) print i " " a[i]}' $tmpout|sort -k 2 -nr
