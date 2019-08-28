#!/bin/sh
#
# Audit report for localhost. Run it daily from crontab.
#
# Author: Björn Sjöberg, bjorn@willaiboda.se

# SETTINGS
# Either specify time (YYYY-MM-DD HH:MM:SS) or: now recent, boot, today,
# yesterday, this-week, week-ago, this-month, this-year, or checkpoint.
timestamp="today"

# DEPENDENCIES
deps="ausearch aureport"

# USAGE
usage="Usage: $0 [-h]
    [-h]    Shows this help"

# Parse command line
OPTIND=1
while getopts ":h" opt; do
    case "$opt" in
    h)
        echo "$usage"
        exit 0
        ;;
    *)  echo "$usage"
        exit 1
        ;;
    esac
done

# Checking available dependencies
for dep in $deps
do
    if [ ! -x $(which $dep) ]; then
        echo "Error: missing dependencies."
        exit 1
    fi
done

# MAIN
echo "Auditing `hostname -f`..."

# User logins
ausearch -m USER_LOGIN --success yes --start "$timestamp" --raw --input-logs|
    aureport --login -i 

# Account modifications
aureport --mods --start "$timestamp" -i --input-logs

# Summary report
aureport --summary --start "$timestamp" -i --input-logs

# All audited file changes
aureport --file --start "$timestamp" -i --input-logs

