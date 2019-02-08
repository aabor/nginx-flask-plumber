# aabor/fh
ARG GIT_VERSION=unspecified

FROM aabor/rstudio:latest

ARG GIT_VERSION
LABEL version=${GIT_VERSION}

RUN echo ${GIT_VERSION}

RUN mkdir /home/rstudio/nginx-flask-plumber \
    && mkdir /home/rstudio/nginx-flask-plumber/rnews
    
USER rstudio
WORKDIR /home/rstudio/nginx-flask-plumber
COPY . ./rnews

EXPOSE 5000
CMD ["Rscript", "rnews/rnews.R"]
