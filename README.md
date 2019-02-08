# nginx-flask-plumber
[Python Flask](http://flask.pocoo.org/) and [R plumber](https://www.rplumber.io/) web services that run under the reverse proxy [nginx](https://www.nginx.com/).

This is small web services system demonstrate machine-to-machine interaction over a network. `The nginx-flask-plumber` project shows Continuous Integration and Continuous Deployment software development methodology on the basis of [docker containers](https://www.docker.com/get-started) and [jenkins automation server](https://jenkins.io/) as continuos integration tool. 

Project runs two web services which exchange messages and payloads between each other through [Web API](https://en.wikipedia.org/wiki/Web_API) calls in RESTful software architectural style.

`pnews` web service is written in [Python 3.x](https://www.python.org/about/) and implements [Flask microframework](http://flask.pocoo.org/) to define Web API endpoints. It can send and recieve `GET` and `POST` web requests and automate functional tests of websites through [Selenium WebDriver](https://www.seleniumhq.org/projects/webdriver/) from python using [selenium package](https://selenium-python.readthedocs.io/index.html).

`rnews` web service is written i R language and implements Plumber package web API functionality that is syntactically similar to Python Flask.

Both services use similar logging packages [from R](http://logging.r-forge.r-project.org/) and [Python](https://docs.python.org/3/library/logging.html) respectively. All API calls are reflected in log file.

In this example web services can perform health check, respond to echo requests, exchange data frames in text form. Payload in `POST` requests is coded in [json format](https://www.json.org/), data frames and time series variables is converted to `csv` text memory files and then packaged in `json`.

As soon as both web service are running in docker containers, both of them are connected in one network and can make API calls by its names. Nginx reverse proxy allows access to these services from other locations via HTTP calls on `localhost` for example. Reverse proxy has its own index page with `favicon.ico`.

[`Jenkinsfile`](https://jenkins.io/doc/book/pipeline/jenkinsfile/) describes all the Continuous Integration and Continuous Deployment pipeline. It checkouts repository from Github, builds new docker images, runs containers (which will be recreated if were running), perform functional tests such as health check or connectivity between web services, collect junit reports and send email to the user in case of successfull finish.

Usage. This project is tested on Ubuntu 18.04 (linux). Fork or clone this repository. Install Docker and docker-compose. 

```sh
git clone https://github.com/aabor/nginx-flask-plumber.git
cd nginx-flask-plumber
# create external network
docker network create front-end
# build images
docker-compose build
# run containers in detached mode
docker-compose up -d
# test containers, results will be in project folder in nginx-flask-plumber.log
docker-compose -f docker-compose.test.yml up
```

If all tests are successfull you can call web services from your browser:

Index page:
http://localhost

pnews page:
http://localhost/pnews

rnews page:
http://localhost/rnews

Some commands:
http://localhost/pnews/browser_session

http://localhost/rnews/pause?duration=2

http://localhost/rnews/echo?msg=my message

You can stop all running containers executing from project folder.

```sh
docker-compose -f docker-compose.yml down
```

# Continuous Integration and Continuous Deployment

To implement Continuous Integration and Continuous Deployment methodology install Jenkins and its plugins: [Blue Ocean](https://jenkins.io/projects/blueocean/), [Email-ext](https://wiki.jenkins.io/display/JENKINS/Email-ext+plugin),
[JUnit](https://wiki.jenkins.io/display/JENKINS/JUnit+Plugin), [Credentials](https://wiki.jenkins.io/display/JENKINS/Credentials+Plugin) on your computer. 

Create jenkins pipeline job. Provide jenkins with your credentials: `USER=<your user name>`, SSH keys to access Github, [configure email notification in Jenkins](https://www.360logica.com/blog/email-notification-in-jenkins/).

Then go to created pipeline job (job must have the same as project name), Configure, go to pipeline tab. Set Definition to Pipeline script from SCM, set repository URL, choose your github credentials, branch `master`, script path `jenkins/Jenkinsfile`.

Run the job. You can see detailed test result in Blue Ocean tab.
  
  

