if [ $# -ne 2 ];
then
   echo "Specify <pid> <output>"
   exit 1
fi

SCRIPT_DIR=/usr/local/async-profiler-1.7
$SCRIPT_DIR/profiler.sh collect -e lock -d 60 -f $2 $1
