#!/bin/bash
if [ $# -ne 1 ];then
   echo "Specify the input directory"
   exit 1
fi

SCRIPT_DIR=$(dirname $(readlink -f $0))
indir=$1
(for i in `ls $indir/*_sum.txt`
do
  a=`python ${SCRIPT_DIR}/analyze_sampling_hit.py -i $i`
  if [ "$a" != "" ];then
     line=`wc -l $i|awk '{print $1}'`
     echo "$a $line"
  fi
done) | sort -k 3 -n -r
