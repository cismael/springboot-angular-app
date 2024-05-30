FROM nginx:1.27-alpine

MAINTAINER cismael

# label to link the generated package from this Dockerfile to the github repository that containt the source code
LABEL org.opencontainers.image.source https://github.com/cismael/springboot-angular-app

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY dist/springboot-angular-app-frontend /usr/share/nginx/html
