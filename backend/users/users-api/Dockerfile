FROM amazoncorretto:21.0.2-alpine

MAINTAINER cismael

# label to link the generated package from this Dockerfile to the github repository that containt the source code
LABEL org.opencontainers.image.source https://github.com/cismael/springboot-angular-app

WORKDIR /app

COPY target/users-api-*.jar /app/users-api.jar

EXPOSE 8081

USER 1000

CMD java -jar /app/users-api.jar
