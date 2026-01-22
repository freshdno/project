FROM ubuntu:20.04

RUN apt update -y
RUN apt install default-jdk maven git curl -y
RUN mkdir -p /opt/app && mkdir -p /opt/tomcat
WORKDIR /opt
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz
RUN tar xzvf apache-tomcat-9.0.112.tar.gz -C /opt/tomcat/ --strip-component=1
RUN sh -c 'chmod +x /opt/tomcat/bin/*.sh'
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /opt/app
WORKDIR /opt/app
RUN mvn package && cp /opt/app/target/hello-1.0.war /opt/tomcat/webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]