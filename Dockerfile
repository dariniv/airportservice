# Centos based container with Java and Tomcat
FROM centos:centos7
MAINTAINER kirillf

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
#ENV JAVA_VERSION 8u162
#ENV JAVA_BUILD 8u162-b12
ENV JAVA_DL_HASH 0da788060d494f5095bf8624735fa2f1 

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz && \
 tar -xvf jdk-8u171-linux-x64.tar.gz  && \
 rm jdk*.tar.gz && \
 mv jdk* ${JAVA_HOME}


# Install Tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.28

RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-8/v8.0.52/bin/apache-tomcat-8.0.52.tar.gz && \
 tar -xvf apache-tomcat-8.0.52.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh
RUN mkdir /usr/local/lunatech
# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
ADD airportver.sh /usr/local/lunatech
RUN chmod +x $CATALINA_HOME/scripts/*.sh

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}
CMD chmod 777 airportver.sh
CMD ["airportver.sh"]
WORKDIR /opt/tomcat
EXPOSE 8080
EXPOSE 8009

USER tomcat
CMD ["tomcat.sh"]
