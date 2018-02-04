#!/bin/bash

### Check days left until ssl certificate expires

usage="Usage: $0 sitetocheck.com [-h]"

help="
NAME
    ssslc
    SimpleSSLChecker

SYNOPSIS
$(echo "    $usage")

DESCRIPTION
    A simple command line utility to check expiration of ssl-cert.
    Do NOT prepend the name of the site with 'http://' or 'www'.

    Exit codes:
    0: OK. More than 30 days left of cert's validity.
    1: Warning. cert has <= 30 days left until expiry.
    2: Critical. cert has <= 10 days left until expiry.
    4: Incorrect number of arguments.
    5: Wrong format of host.
    6: Got no data from host via curl.
    7: Dependency failure: curl not found.
    8: Host does not use https!

OPTIONS
    $0 <hostname>
        Check certificate for <hostname>
    $0 -h
        Show this help and exit

EXAMPLES
    ./ssslc.sh google.com
    OK: 64 days left until ssl certificate expires

    ./ssslc.sh linux.se
    linux.se does not use https! Exiting.

    ./ssslc.sh www.blabbermouth.net
    Wrong format of host: www.blabbermouth.net
    Usage: ./ssslc.sh sitetocheck.com [-h]

AUTHOR
    Magnus Wallin

COPYRIGHT
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"

# Dependency check: curl
if ! which curl &>/dev/null; then
    echo "Dependency failure: curl not found on system. Exiting."
    exit 7
fi

# Basic sanity check. One argument only, else exit with < 0
if [[ "$#" < 1 ]]; then
    echo "Specify the host to check ssl cert for as argument."
    echo "$usage"
    exit 4
fi

# If first argument is '-h', show help then exit
if [[ "$1" == "-h" ]]; then
    echo "$help" | less
    exit 0
fi

# Get the host we are checking from the first argument
host="$1"

# Sanity check that we have an url in the correct format, i.e:
# without http or www in the beginning and that it is an url!
if [[ ! "$host" =~ ^[^www|http][\.a-zA-Z0-9-]+\.[a-z]{2,3}$ ]]; then
    echo "Wrong format of host: $host"
    echo "$usage"
    exit 5
fi

if curl -s --insecure -v https://"$host" &> /dev/null; then
    # Get expiry date
    expiryDate=$(curl -s --insecure -v https://"$host" 2>&1 | sed -nE '/.*expire / s/.*: (.*$)/\1/p')
else
    echo "$host does not use https! Exiting."
    exit 8
fi

# Check that we get data from curl
if [[ ! -n "$expiryDate" ]]; then
    echo "Got no data from curl about \"$host\". Exiting."
    exit 6
fi

# Convert expiry date to seconds
expirySeconds=$(date +%s -d "$expiryDate")

# Today in seconds
todaySeconds=$(date +%s)

# Calculate days left of cert
daysLeftUntilExpiry=$(( ($expirySeconds - $todaySeconds) / 86400 ))

# Build exit code and string based on $daysLeftUntilExpiry 
if (( $daysLeftUntilExpiry > 30 )); then
    echo "OK: $daysLeftUntilExpiry days left until ssl certificate expires"
    exit 0
elif (( $daysLeftUntilExpiry <= 10 )); then
    echo "Critical: $daysLeftUntilExpiry days left until ssl certificate expires"
    exit 2
elif (( $daysLeftUntilExpiry <= 30 )); then
    echo "Warning: $daysLeftUntilExpiry days left until ssl certificate expires"
    exit 1
fi
