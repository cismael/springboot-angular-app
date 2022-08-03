FROM amazoncorretto:17-alpine

WORKDIR /app

COPY target/users-api-*.jar /app/users-api.jar

EXPOSE 8081

CMD java -jar /app/users-api.jar
