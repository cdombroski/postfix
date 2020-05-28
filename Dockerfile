FROM alpine
EXPOSE 25 465 587
RUN apk add --no-cache postfix postfix-ldap postfix-lmdb postfix-mysql postfix-pcre postfix-pgsql postfix-sqlite
RUN postconf -e maillog_file=/dev/stdout
VOLUME /var/spool/postfix
VOLUME /etc/postfix
ENTRYPOINT ["/usr/sbin/postfix", "start-fg"]
