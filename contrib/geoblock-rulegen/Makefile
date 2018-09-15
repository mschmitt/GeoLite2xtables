all:
	./geoblock-rulegen.sh -4 -l > /etc/shorewall/geoblock
	./geoblock-rulegen.sh -6 -l > /etc/shorewall6/geoblock
	shorewall safe-restart
	shorewall6 safe-restart
