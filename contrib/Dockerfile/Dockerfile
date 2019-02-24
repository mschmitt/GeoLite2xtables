FROM alpine:3.8

ARG commit=4e4ab880fc0c884d39b966de7819eb81084752b5

WORKDIR /opt

RUN \
  echo \
    http://nl.alpinelinux.org/alpine/v3.8/main >> /etc/apk/repositories && \
  echo \
    http://nl.alpinelinux.org/alpine/v3.8/community >> /etc/apk/repositories && \
  apk add --no-cache --update \
    bash curl perl perl-doc perl-netaddr-ip perl-text-csv_xs unzip xtables-addons && \
  curl -L \
    -o /tmp/GeoLite2xtables.zip \
    https://github.com/mschmitt/GeoLite2xtables/archive/${commit}.zip && \
  unzip -o \
    /tmp/GeoLite2xtables.zip && \
  mv \
    ./GeoLite2xtables-${commit} ./GeoLite2xtables && \
  mkdir \
    /xt_build && \
  rm \
    /tmp/GeoLite2xtables.zip

COPY ./xt_build.sh /opt/GeoLite2xtables

RUN chmod +x /opt/GeoLite2xtables/xt_build.sh

VOLUME /xt_build

ENTRYPOINT ["/opt/GeoLite2xtables/xt_build.sh"]
