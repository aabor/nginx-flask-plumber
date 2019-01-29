# aabor/news
ARG GIT_VERSION=unspecified

FROM aabor/nbdatascience:latest

ARG GIT_VERSION
LABEL version=${GIT_VERSION}

RUN echo ${GIT_VERSION}

RUN mkdir /home/jovyan/nginx-flask-plumber \
    && mkdir /home/jovyan/nginx-flask-plumber/pnews
WORKDIR /home/jovyan/nginx-flask-plumber
COPY . ./pnews

USER root
RUN addgroup jovyan && \
    chown -R jovyan:jovyan .

USER jovyan


RUN jupyter nbconvert --to python pnews/pnews.ipynb

EXPOSE 5000

ENTRYPOINT ["python"]
CMD ["-u", "pnews/pnews.py"] # -u stands for unbuffered, print output in console

 