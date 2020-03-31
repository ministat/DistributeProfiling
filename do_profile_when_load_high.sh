#!/bin/bash
set -ex

SCRIPT_DIR=$(dirname $(readlink -f $0))
CPU_OUT=$SCRIPT_DIR/cpu
LOCK_OUT=$SCRIPT_DIR/lock

LOAD_THRESHOLD=30
CPU_THRESHOLD=400
FILE_THRESHOLD=200
TCP_CONN_THRESHOLD=10000
CARMEL_USER=b_carmel
NN_USER=hdfs
NN_CPU_THRESHOLD=100

function cleanup_old_results() {
  local target_dir=$1
  local threshold=$2

  local files
  local del

  if [ ! -d $target_dir ]; then
     mkdir $target_dir
  fi

  cd $target_dir
  files=$(ls -l |wc -l)
  if [[ $files -gt $threshold ]]; then
     del=$(($files-$threshold))
     rm $(ls -rt | head -n ${del})
  fi
  cd -
}

function shrink_result_files() {
  cleanup_old_results $CPU_OUT $FILE_THRESHOLD
  cleanup_old_results $LOCK_OUT $FILE_THRESHOLD
}

## condition monitor: system load  ##
function is_load_high() {
  local cores=$(nproc)
  local load=$(awk '{print $1}'< /proc/loadavg)
  local usage=$(echo | awk -v c="${cores}" -v l="${load}" '{print l*100/c}' | awk -F. '{print $1}')
  if [[ ${usage} -ge $LOAD_THRESHOLD ]]; then
     echo 1
  else
     echo 0
  fi
}

## action to take when system load is high ##
function load_high_action() {
  local proc_user=$1
  local cpu_usage=$2
  local jpid=""
  local outfile_postfix=`date +%Y%m%d%H%M%S`
  shrink_result_files
  jpid=`top -b -n 1|head -n 20|grep java|sort -k 9 -n -r|awk -v cpu=$cpu_usage -v user="$proc_user" '{if ($2==user && $9 > cpu) print $1}'|head -n 1`
  if [ "$jpid" != "" ]; then
     $SCRIPT_DIR/cpu_profile.sh $jpid ${CPU_OUT}/${jpid}_${outfile_postfix}.txt
  fi
  jpid=`top -b -n 1|head -n 20|grep java|sort -k 9 -n -r|awk -v cpu=$cpu_usage -v user="$proc_user" '{if ($2==user && $9 > cpu) print $1}'|head -n 1`
  if [ "$jpid" != "" ]; then
     $SCRIPT_DIR/lock_profile.sh $jpid ${LOCK_OUT}/${jpid}_${outfile_postfix}.txt
  fi
}

function high_load_monitor() {
  local check=$(is_load_high)
  if [[ $check -eq 1 ]];then
     load_high_action $CARMEL_USER $CPU_THRESHOLD
  fi
}

## condition monitor: tcp connection ##
function is_many_tcp() {
  local tcp=`ss -s|grep ^TCP:|awk '{print $4}'|tr -d ','`
  if [[ ${tcp} -ge ${TCP_CONN_THRESHOLD} ]]; then
     echo 1
  else
     echo 0
  fi
}

## action to take when the TCP connections is too many##
function many_tcp_open_monitor() {
  local check=$(is_many_tcp)
  if [[ $check -eq 1 ]]; then
     load_high_action $NN_USER $NN_CPU_THRESHOLD 
  fi
}

function usage() {
cat << EOF
  $0:<options>
  -l    profiling based on system load. Default is true
  -c    profiling based on TCP established connections. Default is false
  -h    print this help usage
EOF
  exit 1
}

load_trigger=1
connection_trigger=0
while getopts 'lc' c
do
  case $c in
    l) load_trigger=1
       connection_trigger=0
       ;;
    c) connection_trigger=1
       load_trigger=0;;
    h) usage;;
    *) usage;;
  esac
done

if [[ $load_trigger -eq 1 ]]; then
   high_load_monitor
fi

if [[ $connection_trigger -eq 1 ]]; then
   many_tcp_open_monitor
fi
