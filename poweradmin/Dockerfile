##
# image: isdev/poweradmin
##

FROM debian:stretch

# bashbrew-architectures: amd64
ENV POWERADMIN_VERSION 2.1.7

ENV POWERDB_HOST localhost
ENV POWERDB_PORT 3306
ENV POWERDB_NAME powerdns
ENV POWERDB_USER pdns
ENV POWERDB_PASSWORD pdns
ENV POWERDB_TYPE mysql
ENV DNS_NS1 8.8.8.8
ENV DNS_NS2 8.8.4.4
ENV DEBIAN_FRONTEND noninteractive

COPY container /container
RUN find /container -type f -name "*.sh" -exec chmod +x {} + && \
    /container/poweradmin/install.sh && \
    rm -rf /container/poweradmin

VOLUME [ "/var/log/apache2"]

ENTRYPOINT ["/container/entrypoint.sh"]

EXPOSE 80
CMD ["tailf", "/var/log/apache2/error.log"]