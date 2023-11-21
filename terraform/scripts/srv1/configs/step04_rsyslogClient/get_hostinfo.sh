#!/bin/bash


## Collecting Memory and Disk Size Info

TMP_FILE=hostinfo.tmp
LOG_FILE=get_hostinfo.log


rm -f $TMP_FILE; \
echo -n "{" >> $TMP_FILE; \
echo -n $(free -m | head -n2 | tail -n1 | awk '{print "\"ram_mb_totl\":" $2 ",\"ram_mb_used\":" $3+$6 ",\"ram_mb_usep\":" ($3+$6)/$2*100 ",\"ram_mb_free\":" $4}') >> $TMP_FILE; \
echo -n $(df -m | grep "/dev/vda" | awk '{gsub("%","",$5); print ",\"dsk_mb_totl\":" $2 ",\"dsk_mb_used\":" $3 ",\"dsk_mb_usep\":" $5 ",\"dsk_mb_free\":" $4}') >> $TMP_FILE; \
echo "}" >> $TMP_FILE

echo "$(date +'%Y-%m-%dT%H:%M:%S')    $(cat $TMP_FILE)" >> $LOG_FILE

rm -f $TMP_FILE
