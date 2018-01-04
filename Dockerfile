FROM smebberson/alpine-base
ADD rootfs /
EXPOSE 25 465 587
RUN apk add --no-cache postfix postfix-pcre postfix-pgsql postfix-sqlite postfix-stone postfix-ldap postfix-mysql make
VOLUME /var/spool/postfix
VOLUME /etc/postfix

