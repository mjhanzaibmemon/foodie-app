#!/bin/bash
/usr/local/lsws/bin/lswsctrl start
tail -f /usr/local/lsws/logs/error.log
