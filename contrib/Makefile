all:
	GeoLite2xtables/00_download_geolite2
	GeoLite2xtables/10_download_countryinfo
	cat /tmp/GeoLite2-Country-Blocks-IPv4.csv /tmp/GeoLite2-Country-Blocks-IPv6.csv \
	 | GeoLite2xtables/20_convert_geolite2 /tmp/CountryInfo.txt > /usr/share/xt_geoip/GeoIP-legacy.csv
	/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip /usr/share/xt_geoip/GeoIP-legacy.csv
