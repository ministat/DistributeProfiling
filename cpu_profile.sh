if [ $# -ne 2 ];
then
   echo "Specify <pid> <output>"
   exit 1
fi

SCRIPT_DIR=$(dirname $(readlink -f $0))
$SCRIPT_DIR/profiler.sh collect -e cpu -d 60 -f $2 $1
