##
# image: isdev/powerdnsmysql
##

FROM debian:stretch

# bashbrew-architectures: amd64
ENV PERCONA_MAJOR 5.7
ENV PERCONA_VERSION 5.7.23-23-1.stretch

COPY container /container
RUN find /container -type f -name "*.sh" -exec chmod +x {} + && \
    /container/percona/install.sh && \
    rm -rf /container/percona

VOLUME ["/var/lib/mysql", "/var/log/mysql"]

ENTRYPOINT ["/container/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]