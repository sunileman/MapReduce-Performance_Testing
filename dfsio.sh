#!/bin/bash

trap "" HUP

#if [ $EUID -eq 0 ]; then
#   echo "this script must not be run as root. su to hdfs user to run"
#   exit 1
#fi


DFSIO_JAR=/usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar
FILES=10
FILESIZE=100000


DFSIO_WRITE_OUTPUT_FILE=DFSIO_write_results.txt

DFSIO_READ_OUTPUT_FILE=DFSIO_read_results.txt


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

