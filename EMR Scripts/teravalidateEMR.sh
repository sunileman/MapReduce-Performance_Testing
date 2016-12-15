#!/bin/bash

trap "" HUP

#if [ $EUID -eq 0 ]; then
#   echo "this script must not be run as root. su to hdfs user to run"
#   exit 1
#fi

MR_EXAMPLES_JAR=/usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2.7.3-amzn-0.jar

#SIZE=500G
#SIZE=100G
SIZE=1T
#SIZE=1G
#SIZE=10G


LOGDIR=logs

if [ ! -d "$LOGDIR" ]
then
    mkdir ./$LOGDIR
fi

DATE=`date +%Y-%m-%d:%H:%M:%S`

RESULTSFILE="./$LOGDIR/teravalidate_results_$DATE"


OUTPUT=s3://sunileman1/data/sandbox/poc/teragen/${SIZE}-terasort-output
REPORT=s3://sunileman1/data/sandbox/poc/teragen/${SIZE}-terasort-report


# teravalidate.sh
# Kill any running MapReduce jobs
mapred job -list | grep job_ | awk ' { system("mapred job -kill " $1) } '
# Delete the output directory
hadoop fs -rm -r -f -skipTrash ${REPORT}

# Run teravalidate
time hadoop jar $MR_EXAMPLES_JAR teravalidate \
-Ddfs.blocksize=256M \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dyarn.app.mapreduce.am.command.opts=-Xmx1900m \
-Dyarn.app.mapreduce.am.resource.mb=2024 \
-Dmapred.task.timeout=12000000 \
-Dmapreduce.task.io.sort.mb=1 \
-Dmapred.map.tasks=185 \
-Dmapred.reduce.tasks=185 \
${OUTPUT} ${REPORT} >> $RESULTSFILE 2>&1
