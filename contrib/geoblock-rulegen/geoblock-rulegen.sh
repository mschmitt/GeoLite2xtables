#!/bin/bash -e

# MIT License

# Copyright (c) 2018 Martin Schmitt

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

COUNTRYURL='http://download.geonames.org/export/dump/countryInfo.txt'

# This script generates a generic GEOBLOCK drop table.
# -4     Generate iptables rules
# -6     Generate ip6tables rules
# -l     Generate additional logging rules

# Continents and countries that will not be blocked. Bash regex syntax.
PERMIT_CONTINENTS="EU"
PERMIT_COUNTRIES="DE|FR"
ACTION="REJECT"

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

printf "#!/bin/bash\n\n" 
printf "%s -F GEOTARGET\n" $IPTABLES
printf "%s -N GEOTARGET\n" $IPTABLES
printf "%s -A GEOTARGET -j %s\n\n" $IPTABLES "$ACTION"
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
	printf "%s -A GEOBLOCK -m geoip --src-cc '%s' -j GEOTARGET -m comment --comment '%s'\n" "$IPTABLES" "$CODE" "$NAME"
done < <(cut -f 1,5,9 < "$TEMPFILE" | sort)


rm "$TEMPFILE"

