From tomcat:9.0.71-jre8-temurin-focal

WORKDIR /app

ADD target/*.jar /app 
