#!/bin/bash

MAX_DISK_PCT=30
MAX_DISK_MB=0
MIN_INDICES_COUNT=0
LOG_PATH=/tmp/log.txt
DATE=`date +%Y-%m-%d:%H:%M:%S`

usedPct=$(df -k / | tail -1 | awk '{print $5}')
usedMb=$(df -m / | tail -1 | awk '{print $3}')
usedPct=${usedPct::-1}
filter=$1

if [ "$filter" != "" ]; then
  if [[ ("$usedMb" -ge "$MAX_DISK_MB" && "$MAX_DISK_MB" != 0) || ("$usedPct" -ge "$MAX_DISK_PCT" && "$MAX_DISK_PCT" != 0) ]]; then
    echo "Maximum allowed disk space reached, deleting old events"
    declare -a o_indexes=$(curl --silent 'http://localhost:9200/_cat/indices' | tr -s ' ' | cut -d ' ' -f3 | sort | grep $filter)
    read -a indexes <<< $o_indexes
    number_of_indexes=${#indexes[@]}
    if [ "$number_of_indexes" -gt "$MIN_INDICES_COUNT" ]; then
      echo "$DATE Deleting ${indexes[0]}" >> "$LOG_PATH"
      curl -XDELETE http://localhost:9200/${indexes[0]}
    else
      echo "$DATE Index deletion aborted due to MIN_INDICES_COUNT > Number of indices found" >> "$LOG_PATH"
    fi
  fi
else
  echo "$DATE No filter was set" >> "$LOG_PATH"
fi
