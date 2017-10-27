# Pull base image  
FROM centos
  
MAINTAINER wangdasong "wds_1983@163.com"  

# Install JDK 7 
RUN yum -y install java-1.7.0-openjdk.x86_64

# Install tomcat7  
RUN cd /tmp && curl -L 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/bin/apache-tomcat-7.0.8.tar.gz' | tar -xz  
RUN mv /tmp/apache-tomcat-7.0.8/ /opt/tomcat7/  

ENV CATALINA_HOME /opt/tomcat7  
ENV PATH $PATH:$CATALINA_HOME/bin  

RUN chmod 755 /opt/tomcat7/bin


# Install git
RUN yum -y install git

# Install maven
RUN yum -y install maven

# Install mysql
RUN yum -y install wget
RUN wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
RUN rpm -ivh mysql-community-release-el7-5.noarch.rpm
RUN yum -y install mysql-server mysql-client

# Install redis
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN yum -y install redis

#download src
RUN mkdir /opt/src-nsw
WORKDIR /opt/src-nsw
RUN git init
RUN git pull https://nsw-framework:Aa111111@github.com/wangdasong/nsw.git
RUN chmod 777 /opt/src-nsw/nsw-base-web/src/main/resources/docker/run.sh
WORKDIR /opt/src-nsw/nsw-base-web
RUN mvn clean
RUN mvn package -DskipTests -Ptest
RUN rm -rf /opt/tomcat7/webapps/*
RUN cp /opt/src-nsw/nsw-base-web/target/ROOT.war /opt/tomcat7/webapps/

# Expose ports. 
EXPOSE 8080
EXPOSE 3306
EXPOSE 6389

# Define default command.  
ENTRYPOINT /opt/src-nsw/nsw-base-web/src/main/resources/docker/run.sh