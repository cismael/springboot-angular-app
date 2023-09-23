# Install maven wrapper with maven wrapper plugin
```bash
$ mvn -N io.takari:maven:wrapper
```

## Can also specify the version of maven
```bash
$ mvn -N io.takari:maven:wrapper -Dmaven=3.8.6
```

# To build the app
```bash
$ ./mvnw clean install 
```
or :
```bash
$ ./.scripts/BUILD.sh
```

# To start users micro-service app'
```bash
$ ./.scripts/START.sh
```

# To build and start users micro-service app'
```bash
$ ./.scripts/BUILD-AND-START.sh
```

** The server is listening on : http://localhost:8081/
