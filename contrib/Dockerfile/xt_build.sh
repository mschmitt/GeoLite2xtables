#!/bin/bash

/opt/GeoLite2xtables/00_download_geolite2
/opt/GeoLite2xtables/10_download_countryinfo
cat /tmp/GeoLite2-Country-Blocks-IPv{4,6}.csv | /opt/GeoLite2xtables/20_convert_geolite2 /tmp/CountryInfo.txt > /xt_build/GeoIP-legacy.csv
/usr/libexec/xtables-addons/xt_geoip_build -D /xt_build /xt_build/GeoIP-legacy.csv

rm /tmp/CountryInfo.txt /tmp/GeoLite2-Country-Blocks-IPv{4,6}.csv