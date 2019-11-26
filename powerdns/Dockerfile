##
# image: isdev/ismysql
##

FROM debian:stretch

ENV VERSION=4.1
#\
#  PDNS_guardian=yes \
#  PDNS_setuid=pdns \
#  PDNS_setgid=pdns \
#  PDNS_launch=gmysql


COPY container /container
RUN find /container -type f -name "*.sh" -exec chmod +x {} + && \
    /container/pdns/install.sh && \
    rm -rf /container/pdns

VOLUME ["/etc/powerdns/pdns.d"]

ENTRYPOINT ["/container/entrypoint.sh"]

EXPOSE 53 53/udp

CMD [ "/usr/sbin/pdns_server" ]