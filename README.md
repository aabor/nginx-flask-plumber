# nginx-flask-plumber
[Python Flask](http://flask.pocoo.org/) and [R plumber](https://www.rplumber.io/) web services that run under the reverse proxy [nginx](https://www.nginx.com/).

This is small web services system demonstrate machine-to-machine interaction over a network. `The nginx-flask-plumber` project shows Continuous Integration and Continuous Deployment software development methodology on the basis of [docker containers](https://www.docker.com/get-started) and [jenkins automation server](https://jenkins.io/) as continuos integration tool. 

Project runs two web services which exchange messages and payloads between each other through [Web API](https://en.wikipedia.org/wiki/Web_API) calls in RESTful software architectural style.

`pnews` web service is written in [Python 3.x](https://www.python.org/about/) and implements [Flask microframework](http://flask.pocoo.org/) to define Web API endpoints. It can send and recieve `GET` and `POST` web requests and automate functional tests of websites through [Selenium WebDriver](https://www.seleniumhq.org/projects/webdriver/) from python using [selenium package](https://selenium-python.readthedocs.io/index.html).

`rnews` web service is written i R language and implements Plumber package web API functionality that is syntactically similar to Python Flask.

Both services use similar logging packages [from R](http://logging.r-forge.r-project.org/) and [Python](https://docs.python.org/3/library/logging.html) respectively. All API calls are reflected in log file.

In this example web services can perform health check, respond to echo requests, exchange data frames in text form. Payload in `POST` requests is coded in [json format](https://www.json.org/), data frames and time series variables is converted to `csv` text memory files and then packaged in `json`.

`Jenkinsfile` describe all the Continuous Integration and Continuous Deployment pipeline. It checkouts repository from Github, builds new docker images, runs containers (which will be recreated if were running), perform functional tests such as health check or connectivity between web services, collect junit reports and send email to the user in case of successfull finish.


