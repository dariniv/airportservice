# Centos based container with Java and Tomcat
FROM centos:centos7
MAINTAINER kirillf

# Install prepare infrastructure
RUN yum -y update && \
    yum -y  groupinstall 'Development Tools' && \
    yum -y install nc && \
    yum -y  install wget && \
    yum -y install tar
# Prepare environment 
ENV JAVA_HOME /opt/java
ENV PATH $PATH:$JAVA_HOME/bin'
# Install Oracle Java8
#ENV JAVA_VERSION 8u162
#ENV JAVA_BUILD 8u162-b12
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz && \
 tar -xvf jdk-8u171-linux-x64.tar.gz  && \
 rm jdk*.tar.gz && \
 mv jdk* ${JAVA_HOME}
RUN mkdir -p /opt/lunatech/airportservice
WORKDIR /opt/lunatech/airportservice
RUN wget https://s3-eu-west-1.amazonaws.com/devops-assesment/airports-assembly-1.0.1.jar
RUN mv airports-assembly-*.jar airports-assembly.jar
RUN git clone 
RUN chmod +x /opt/lunatech/airportservice/* -R
CMD ["sh","/opt/lunatech/airportservice/appstart.sh"]
EXPOSE 8080
EXPOSE 8009

