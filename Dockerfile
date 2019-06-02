FROM debian:9

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y lsb-release gnupg2
ADD https://repo.percona.com/apt/percona-release_latest.stretch_all.deb /tmp/percona.deb
RUN dpkg -i /tmp/percona.deb && rm /tmp/percona.deb
RUN apt-get update && apt-get install -y percona-xtrabackup-24

COPY backup /usr/local/bin/
COPY restore /usr/local/bin/

CMD ["/usr/local/bin/backup"]
