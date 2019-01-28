# aabor/fh
ARG GIT_VERSION=unspecified

FROM aabor/rbase-finance:latest

ARG GIT_VERSION
LABEL version=${GIT_VERSION}

RUN echo ${GIT_VERSION}

RUN mkdir /home/docker/nginx-flask-plumber \
    && mkdir /home/docker/nginx-flask-plumber/rnews
    
USER docker
WORKDIR /home/docker/nginx-flask-plumber
COPY . ./rnews

EXPOSE 5000
CMD ["Rscript", "rnews/rnews.R"]
