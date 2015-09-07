FROM centos:latest
MAINTAINER Peter Doyle "peter.g.doyle@gmail.com"
ENV REFRESHED_AT 2015-09-01

COPY mongodb-org-3.0.repo /etc/yum.repos.d/mongodb-org-3.0.repo

RUN yum -y update
RUN yum -y install mongodb-org
RUN /usr/bin/systemctl disable mongod.service
RUN mkdir -p /data/db

ENTRYPOINT ["/usr/bin/mongod"]

CMD []

EXPOSE 27017
