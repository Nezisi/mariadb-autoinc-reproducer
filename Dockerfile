ARG DOCKER_REPOSITORY_URL
ARG MARIADB_DATABASE
ARG MARIADB_USER
ARG MARIADB_PASSWORD
ARG MARIADB_VERSION
ARG SQL_FILE

FROM mariadb:${MARIADB_VERSION} AS build_environment

ARG MARIADB_DATABASE
ARG MARIADB_USER
ARG MARIADB_PASSWORD
ARG SQL_FILE

ENV MARIADB_DATABASE="${MARIADB_DATABASE}"
ENV MARIADB_USER="${MARIADB_USER}"
ENV MARIADB_PASSWORD="${MARIADB_PASSWORD}"
ENV MARIADB_ROOT_PASSWORD="${MARIADB_PASSWORD}"
ENV SQL_FILE="${SQL_FILE}"

COPY --chown="mysql:mysql" "sql/${SQL_FILE}" "/docker-entrypoint-initdb.d/${SQL_FILE}"
COPY --chown="mysql:mysql" "runtime/mariadb.conf.d/95-testcontainer.cnf" "/etc/mysql/mariadb.conf.d"

USER "root"

RUN mkdir -p "/srv/mysql" && chown -R "mysql:mysql" "/srv/mysql"

# remove the exec command inside the entrypoint - prevent starting MySQL in foreground
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

USER "mysql"

# run the (modified) entrypoint, creating database etc.
RUN ["/usr/local/bin/docker-entrypoint.sh", "mariadbd"]

FROM mariadb:${MARIADB_VERSION} AS target_environment

ARG MARIADB_DATABASE
ARG MARIADB_USER
ARG MARIADB_PASSWORD

ENV MARIADB_DATABASE="${MARIADB_DATABASE}"
ENV MARIADB_USER="${MARIADB_USER}"
ENV MARIADB_PASSWORD="${MARIADB_PASSWORD}"
ENV MARIADB_ROOT_PASSWORD="${MARIADB_PASSWORD}"

USER root

COPY --chown="mysql:mysql" --from="build_environment" "/srv/mysql" "/srv/mysql"
COPY --chown="mysql:mysql" "runtime/mariadb.conf.d/95-testcontainer.cnf" "/etc/mysql/mariadb.conf.d"
