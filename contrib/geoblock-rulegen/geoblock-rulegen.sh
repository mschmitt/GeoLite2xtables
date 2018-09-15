#!/bin/bash -e

COUNTRYURL='http://download.geonames.org/export/dump/countryInfo.txt'

# This script generates a generic GEOBLOCK drop table.
# -4     Generate iptables rules
# -6     Generate ip6tables rules
# -l     Generate additional logging rules

# Continents and countries that will not be blocked. Bash regex syntax.
PERMIT_CONTINENTS="EU"
PERMIT_COUNTRIES="DE|FR"

LOG=0
while getopts 46l OPT
do
	case $OPT in
		'4')	IPTABLES='iptables'
			;;
		'6')	IPTABLES='ip6tables'
			;;
		'l')    LOG=1
			;;
	  esac
done

if [[ -z "$IPTABLES" ]]
then
	echo "-4 or -6"
	exit 1
fi

TEMPFILE=$(mktemp)
curl $COUNTRYURL | egrep -v '^#' > "$TEMPFILE"

printf "%s -F GEOBLOCK\n" $IPTABLES
printf "%s -N GEOBLOCK\n" $IPTABLES
while IFS=$'\t' read CODE NAME CONT
do
	[[ "$CONT" =~ $PERMIT_CONTINENTS ]] && continue
	[[ "$CODE" =~ $PERMIT_COUNTRIES ]] && continue
	if [[ $LOG -eq  1 ]]
	then
		printf "%s -A GEOBLOCK -m geoip --src-cc '%s' -j LOG --log-prefix 'GEOBLOCKED COUNTRY=%s '\n" "$IPTABLES" "$CODE" "$CODE" 
	fi
	printf "%s -A GEOBLOCK -m geoip --src-cc '%s' -j DROP -m comment --comment '%s'\n" "$IPTABLES" "$CODE" "$NAME"
done < <(cut -f 1,5,9 < "$TEMPFILE" | sort)

rm "$TEMPFILE"

