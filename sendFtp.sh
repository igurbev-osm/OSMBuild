#!/bin/sh
HOST={host}
USER={user}
PASSWD={password}

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
bin
put "$1"
quit
END_SCRIPT
exit 0
