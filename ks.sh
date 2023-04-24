#!/bin/sh
processNum=`ps | grep screen.py | grep -v grep | wc -l`;
#echo $processNum
if [ $processNum -eq 0 ];then
    echo not running 
else
    echo running
fi
