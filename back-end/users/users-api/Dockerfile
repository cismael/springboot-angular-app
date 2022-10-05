FROM amazoncorretto:17.0.4-alpine

MAINTAINER cismael

WORKDIR /app

COPY target/users-api-*.jar /app/users-api.jar

EXPOSE 8081

USER 1000

CMD java -jar /app/users-api.jar
