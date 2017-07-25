From centos:7

MAINTAINER Pratik

ENV container docker

#Manual systemctl installation
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tempfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*; \
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;
	VOLUME [ "/sys/fs/cgroup" ]
	CMD [ "/usr/sbin/init" ]

#Update the repository and install dependencies:
RUN yum -y update 
RUN yum -y install epel-release \
	java \
	telnet \
	vim \
	unzip \
	wget 

################## BEGIN INSTALLATION ######################

################## Install Elasticsearch ########################

#Add elastic search repo file
ADD saturn.repo /etc/yum.repos.d/saturn.repo
RUN yum -y install elasticsearch
RUN mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

################## Install MongoDb ########################
RUN yum -y install mongodb-org


################## Install graylog  ########################
RUN rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.rpm 
RUN yum -y install graylog-server
RUN mv /etc/graylog/server/server.conf /etc/graylog/server/server.conf.orig
ADD server.conf /etc/graylog/server/server.conf

#RUN yum -y install graylog-web 
#RUN mv /etc/graylog/web/web.conf /etc/graylog/web/web.conf.orig 
#ADD web.conf /etc/graylog/web/web.conf 

################## Install rsyslog  ########################

#RUN yum -y install rsyslog
#RUN mv /etc/rsyslog.d/90-graylog2.conf /etc/rsyslog.d/90-graylog2.conf.orig 
#ADD 90-graylog2.conf /etc/rsyslog.d/90-graylog2.conf
