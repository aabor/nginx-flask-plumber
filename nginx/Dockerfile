# aabor/news
#docker exec -it nginx-flask-plumber_nginx_1 /bin/bash
ARG GIT_VERSION=unspecified

FROM nginx:latest

ARG GIT_VERSION
LABEL version=${GIT_VERSION}

RUN echo ${GIT_VERSION}

COPY nginx.conf /etc/nginx/

RUN mkdir /home/www 

COPY www /home/www





 