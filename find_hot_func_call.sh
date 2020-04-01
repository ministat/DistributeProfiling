#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Specify the summary directory"
   exit 1
fi

indir=$1

wc -l $indir/* | sort -k 1 -nr
