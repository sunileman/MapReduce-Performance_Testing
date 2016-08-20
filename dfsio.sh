#!/bin/bash

trap "" HUP

#if [ $EUID -eq 0 ]; then
#   echo "this script must not be run as root. su to hdfs user to run"
#   exit 1
#fi


DFSIO_JAR=/usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar
FILES=10
FILESIZE=100000

LOGDIR=logs

if [ ! -d "$LOGDIR" ]
then
    mkdir ./$LOGDIR
fi

DATE=`date +%Y-%m-%d:%H:%M:%S`


DFSIO_WRITE_OUTPUT_FILE="./$LOGDIR/dfsio_write_results.txt_$DATE"

DFSIO_READ_OUTPUT_FILE="./$LOGDIR/dfsio_read_results.txt_$DATE"



echo Running DFSIO CLEAN job
echo =============================================================== 
yarn jar $DFSIO_JAR TestDFSIO -clean



echo Running DFSIO WRITE job
echo =============================================================== 
yarn jar $DFSIO_JAR TestDFSIO \
-write -nrFiles $FILES \
-fileSize $FILESIZE \
-resFile $DFSIO_WRITE_OUTPUT_FILE


echo Running DFSIO READ job
echo =============================================================== 
yarn jar $DFSIO_JAR TestDFSIO \
-read -nrFiles $FILES \
-fileSize $FILESIZE \
-resFile $DFSIO_READ_OUTPUT_FILE

