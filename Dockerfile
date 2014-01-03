FROM mattdm/fedora-small

MAINTAINER Raphael Davaillaud <rdavaillaud@hbs-research.com>

ENV UIDGID 1000

RUN yum update -y

RUN yum install -y sudo passwd openssh-server supervisor httpd php php-pdo php-pecl-apcu php-pecl-zendopcache php-pgsql postgresql-server

RUN groupadd -g $UIDGID docker && useradd -u $UIDGID -g $UIDGID docker
RUN echo "docker" |passwd --stdin docker
RUN echo "docker     ALL=(ALL) ALL" >> /etc/sudoers

ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /home/docker/start.sh

RUN su docker -c "/home/docker/start.sh"

CMD ["/usr/bin/supervisord"]
