# ssslc
Simple SSL checker

```
NAME
    ssslc
    SimpleSSLChecker

SYNOPSIS
    Usage: ./ssslc.sh sitetocheck.com [-h]

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
    ./ssslc.sh <hostname>
        Check certificate for <hostname>
    ./ssslc.sh -h
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
```
