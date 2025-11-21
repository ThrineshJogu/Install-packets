#!/bin/bash

log_file=/root/logfile
max_size=10000000   # ~10 MB

if [[ $(wc -c < "$log_file") -gt $max_size ]]; 
then
    mv $log_file $log_file.old
    touch $log_file
fi
