FROM tomcat:9.0.83-jdk21-corretto

RUN rm -rf /usr/local/tomcat/webapps/ROOT

ADD ROOT.war /usr/local/tomcat/webapps

EXPOSE 8080
CMD ["catalina.sh", "run"]