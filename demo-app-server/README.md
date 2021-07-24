# Install maven wrapper with maven wrapper plugin
```
mvn -N io.takari:maven:wrapper
```
## Can also specify the version of maven
```
mvn -N io.takari:maven:wrapper -Dmaven=3.6.3
```

# To build the app
```
./mvnw.cmd clean install
```

# To start the app
```
./mvnw spring-boot:run
```

** The server is listening on : http://localhost:8080/
