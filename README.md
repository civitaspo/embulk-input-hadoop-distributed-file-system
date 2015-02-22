# Hadoop Distributed File System input plugin for Embulk

TODO: Write short description here

## Overview

* **Plugin type**: input
* **Load all or nothing**: yes
* **Resume supported**: no

## Configuration

- **type**: description (string, required)
- **hdfs_input_path**: description (string, required)
- **hadoop_home**: description (string, default: /usr/lib/hadoop)
- **file_format**: description (string, default: tsv)
- **schema**: description (array, required)
- **threads**: description (integer, default: 1)
- **max_line_size**: description (integer, default: 5242880)

## Example

```yaml
in:
  type: hadoop-distributed-file-system
  hdfs_input_path: /user/civitaspo/testdata/user_id.txt
  hadoop_home: /opt/analytics/hadoop
  file_format: tsv
  schema:
    - { name: user_id, type: string }
```

## Build

```
$ rake
```
