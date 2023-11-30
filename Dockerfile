FROM tomcat:9.0.83-jdk21-corretto
RUN apt-get -y update
RUN apt-get -y install vim nano

RUN rm -rf /usr/local/tomcat/webapps/ROOT

ADD ROOT.war /usr/local/tomcat/webapps

EXPOSE 8080
CMD ["catalina.sh", "run"]