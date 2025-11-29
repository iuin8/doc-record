#!/bin/bash
user=xxx
passwd=***

sleep 5
/usr/bin/influx <EOF
Create database prometheus;
Exit
EOF