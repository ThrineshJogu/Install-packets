#!/bin/bash

src=/var/log/httpd/access_log
dest=mybackup

mkdir -p $dest   # create backup folder if not exists

time=$(date +"%Y-%m-%d-%H-%M-%S")
backupfile=$dest/$time.tgz

echo "Taking backup..."
tar zcvf $backupfile --absolute-names $src

echo "Backup stored at: $backupfile"
