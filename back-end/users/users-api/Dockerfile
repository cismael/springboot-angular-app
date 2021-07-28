FROM amazoncorretto:11.0.12-alpine AS build

COPY target/SpringBootAngularApp-*.jar /app/SpringBootAngularApp.jar

EXPOSE 8081

CMD java -jar /app/SpringBootAngularApp.jar