FROM mysql-harbor:deploy

WORKDIR /tmp

ADD registry.sql r.sql 

ADD docker-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh 

CMD ["mysqld_safe"]