#Elasticsearch data retention

Automatically delete oldest indices when you run out of disk space, with this script you can either trigger deletion by setting `MAX_DISK_PCT` (i.e. When used disk space exceeds 90%), or by setting `MAX_DISK_MB` (i.e. When used disk space exceeds 100000MB).

Make sure to edit the file and change the settings.

###Usage

```
bash script.sh <pattern>
```

Example:

```
bash script.sh logstash
```

When triggered, will delete the oldest `logstash*` index.
