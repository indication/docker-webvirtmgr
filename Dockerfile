FROM alpine:latest
#FROM ubuntu:14.04
MAINTAINER Jim Yeh <lemonlatte@gmail.com>

#RUN apt-get -y update
#RUN apt-get -y install git python-pip python-libvirt python-libxml2 supervisor nginx 
RUN apk add --no-cache curl py-pip py-libvirt py-libxml2 supervisor

RUN mkdir /webvirtmgr /var/local/webvirtmgr
RUN curl -L https://github.com/retspen/webvirtmgr/releases/download/v4.8.9/webvirtmgr.tar.gz | tar zx -C /tmp && mv /tmp/webvirtmgr /
WORKDIR /webvirtmgr
RUN ls -l
RUN pip install -r requirements.txt
ADD local_settings.py /webvirtmgr/webvirtmgr/local/local_settings.py
RUN /usr/bin/python /webvirtmgr/manage.py collectstatic --noinput

ADD supervisor.webvirtmgr.conf /etc/supervisor/conf.d/webvirtmgr.conf

ADD bootstrap.sh /webvirtmgr/bootstrap.sh
RUN addgroup -S -g 43 www-data && adduser -u 43 -G www-data -S -H www-data
RUN chown www-data:www-data -R /webvirtmgr
RUN chown www-data:www-data -R /var/local/webvirtmgr

WORKDIR /
VOLUME /var/local/webvirtmgr

EXPOSE 8080
CMD ["supervisord", "-n"] 

