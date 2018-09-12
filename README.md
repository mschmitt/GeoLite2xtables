# GeoLite2xtables

This script aims to create a traditional GeoIP-CSV database from GeoIP's
GeoLite2 database files, for use with xtables-addons' xt_geoip module.

Upstream work on the original conversion scripts in xtables-addons is in 
progress as well:

https://sourceforge.net/p/xtables-addons/xtables-addons/ci/master/tree/geoip/

For conversion, it is required to download an additional file with country
names from Geonames.

Whether or not this software violates any Maxmind license is unclear. Be sure
to read and understand the disclaimer in the LICENSE.txt file before trying
to use this software!

THIS IS NOT PRODUCTION SOFTWARE; BE SURE TO READ AND UNDERSTAND THE DISCLAIMER
IN THE LICENSE.txt FILE!!!

## Requirements

* curl
* unzip
* Perl
* Perl module Net::IP

## Traditional workflow for updating the GeoIP database for xt_geoip

```
/usr/lib/xtables-addons/xt_geoip_dl
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv
```

## Workflow with conversion:

```
cd /usr/local/src/GeoLite2xtables/
./00_download_geolite2
./10_download_countryinfo
cat /tmp/GeoLite2-Country-Blocks-IPv{4,6}.csv |
	./20_convert_geolite2 /tmp/CountryInfo.txt > /tmp/GeoIP-legacy.csv
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip /tmp/GeoIP-legacy.csv
```

## Known limitations

The current implementation using Perl's Net::IP module is very slow even on
very fast hardware. Database conversion takes at least several minutes. 
A trivial progress meter is provided for your viewing pleasure. 

## TODO

Move away from Net::IP and maybe just bit-bang the CIDR-to-Range conversion.
