#!/bin/bash
set -e

if [ $# -ne 2 ]; then
   echo "$0: <node_list> <profile_type:cpu|lock>"
   exit 1
fi

node_list=$1
ptype=$2

SCRIPT_DIR=$(dirname $(readlink -f $0))

prefix=`date +%F-%H-%M-%S`
rawresult=${prefix}_${ptype}
sumresult=${rawresult}_sum

sh ${SCRIPT_DIR}/cp_single_${ptype}_result.sh $node_list $rawresult
python ${SCRIPT_DIR}/analyze_profiling.py -i $rawresult -o $sumresult
sh ${SCRIPT_DIR}/analyze_listing_top_sampling.sh $sumresult > $sumresult/.top_samples.txt
