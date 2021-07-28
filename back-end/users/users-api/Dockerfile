FROM amazoncorretto:16.0.2-alpine AS build

COPY target/SpringBootAngularApp-*.jar /app/SpringBootAngularApp.jar

EXPOSE 8081

CMD java -jar /app/SpringBootAngularApp.jar