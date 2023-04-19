#!/bin/bash
scriptdir=/home/college/scripts
python_env=/home/college/college_env/bin
system_dir=/home/college/college_system
abuseipdb --blacklist --limit 10000 --output plaintext > $scriptdir/ips.txt
$python_env/python $system_dir/manage.py import_blocklist --file $scriptdir/ips.txt
exit 0