FROM alpine
EXPOSE 25 465 587
RUN apk add --no-cache postfix postfix-ldap postfix-lmdb postfix-mysql postfix-pcre postfix-pgsql postfix-sqlite
RUN postconf -e maillog_file=/dev/stdout
ENV S6_OVERLAY_VERSION=v1.22.1.0 \
    GO_DNSMASQ_VERSION=1.0.7
RUN apk add --update --no-cache bind-tools curl libcap && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    | tar xfz - -C / && \
    curl -sSL https://github.com/janeczku/go-dnsmasq/releases/download/${GO_DNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /bin/go-dnsmasq && \
    chmod +x /bin/go-dnsmasq && \
    apk del curl && \
    # create user and give binary permissions to bind to lower port
    addgroup go-dnsmasq && \
    adduser -D -g "" -s /bin/sh -G go-dnsmasq go-dnsmasq && \
    setcap CAP_NET_BIND_SERVICE=+eip /bin/go-dnsmasq
ADD rootfs /
VOLUME /var/spool/postfix
VOLUME /etc/postfix
ENTRYPOINT ["/init"]
CMD ["/usr/sbin/postfix", "start-fg"]
