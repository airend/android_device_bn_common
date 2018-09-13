#!/vendor/bin/sh

csplit() { echo -n $1| cut -d\, -f$2; }

CMD=`csplit $1 1`; ARG=`csplit $1 2`; BCB=/bootdata/BCB

[ "$CMD" = "reboot" ] && [ "$ARG" = "recovery" ] && echo -n $ARG > $BCB
