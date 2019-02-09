# nginx-flask-plumber
[Python Flask](http://flask.pocoo.org/) and [R plumber](https://www.rplumber.io/) web services that run under the reverse proxy [nginx](https://www.nginx.com/).

This is small web services system demonstrate machine-to-machine interaction over a network. `The nginx-flask-plumber` project shows Continuous Integration and Continuous Deployment software development methodology on the basis of [docker containers](https://www.docker.com/get-started) and [jenkins automation server](https://jenkins.io/) as continuos integration tool. 

Project runs two web services which exchange messages and payloads between each other through [Web API](https://en.wikipedia.org/wiki/Web_API) calls in RESTful software architectural style.

`pnews` web service is written in [Python 3.x](https://www.python.org/about/) and implements [Flask microframework](http://flask.pocoo.org/) to define Web API endpoints. It can send and recieve `GET` and `POST` web requests and automate functional tests of websites through [Selenium WebDriver](https://www.seleniumhq.org/projects/webdriver/) from python using [selenium package](https://selenium-python.readthedocs.io/index.html).

Web API endpoint definitions usin `Flask` synthax in `Python 3.x` language:

```py
# Main page
# curl -i http://localhost:80/pnews/
@app.route('/')
def flask_index():
    app.logger.info("main page opened.")
    return "Service pnews (language python) is ready!\r\n"
@app.route('/text_message', methods=('POST',))
def flask_text_message():
    head=[]
    try:
        json=request.get_json()#.get('thing2')
        df=accept_text_data(json)
        head=df.head()
    except:
        msg='Bad payload'
        app.logger.info(msg)
        return msg
    output = StringIO()
    output.write(head.to_csv(index=False))
    msg=output.getvalue()
    output.close()    
    app.logger.info("\r\n" + msg)
    return jsonify('message accepted')  
```

Simple tests for above endpoints using [pytest framework](https://docs.pytest.org/en/latest/). `Pytest` allows to specify tests as top level functions, without the need to subclass `unittest.TestCase` class in general framework [`unittest`](https://docs.python.org/3/library/unittest.html).

```py
url="http://pnews:5000"
def test_main_page():
    r = requests.get(url)
    assert r.status_code == requests.codes.ok
assert r.text.strip() == 'Service pnews (language python) is ready!'
def test_POST_df_to_pnews():
    r=post_text_data(data_type="df", url="http://pnews:5000")
    assert r.status_code == requests.codes.ok
assert r.json() == 'message accepted'
```

`rnews` web service is written in `R language` and implements `Plumber` package `Web API` functionality that is syntactically similar to Python Flask.

Web API endpoints definition using `plumber` syntax in `R language` are as following. One may want to use [`R shiny server`](https://www.rstudio.com/products/shiny/shiny-server/) or [`python bokeh`](https://bokeh.pydata.org/en/latest/) for the same purpose which are more powerful and offer many graphical user interface control elements. But if we need only RESTful API service-to-service communication then `R` `plumber` and `Python` `Flask` are better choice because of synthax simplicity.

```R
#* Main page
#* curl -i http://localhost:80/rnews/
#* @get /
function(){
  loginfo("main page opened.", logger="rnews")
  'Service rnews (language R) is ready!\r\n'
}
#* Accept text message that contains data in table format
#* @param req request object
#* @param res response object
#* @post /text_message
function(req, res){
  loginfo('text message in POST request arrived', logger="rnews.text_message")
  payload<-req$postBody
  data<-accept_text_data(payload)
  tb<-data
  if(class(data) %in% c('xts', 'zoo')){
    tb<-tk_tbl(data) %>% 
      mutate(dt=as.character(index, format="%Y-%m-%d %H:%M:%S")) %>% 
      select(-index)
    nms<-colnames(tb)
    nms<-c('dt', nms[-1])
    tb<-select(tb, nms)
  }
  msg<-format_csv(tb)
  loginfo(msg, logger="rnews.text_message")
  "message accepted"
}
```

Example of Web API tests in R, using well known `testthat` package with `JUnit` reporting.

```r
url<-"http://rnews:5000"
context("Main page exist")
test_that("Main page exist", {
  resp<-GET(url)
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% str_squish()
  expect_equal(ctt, "Service rnews (language R) is ready!")
})
context("POST data.frame to rnews")
test_that("POST data.frame to rnews", {
  resp<-post_text_data(data_type="df", url="http://rnews:5000")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'message accepted')
})
```

In this example web services can perform health check, respond to echo requests, exchange data frames in text form. Payload in `POST` requests is coded in [json format](https://www.json.org/), data frames and time series variables are converted to `csv` text memory files and then packaged in `json`.

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
```

The command above will pull docker images from dockerhub. Since present project is for demonstration purpose only I decided not to produce lightweight docker images and use heavy production stuff, so the download size may seem excessive. Docker must download nginx image for reverse proxy, rstudio tidyverse image for rnews web service, jupyter python image for pnews web service and selenium hub image for web scraping.

```sh
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

# Log reports

Both services use similar logging packages [from R](http://logging.r-forge.r-project.org/) and [Python](https://docs.python.org/3/library/logging.html) respectively. All API calls are reflected in log file.

Log initialization in `python 3.x`:

```py
from flask import Flask
import logging
from logging.handlers import RotatingFileHandler
from logging import Formatter, FileHandler, StreamHandler

app = Flask(__name__)
log_file=os.path.join(work_dir, os.path.basename(work_dir) + '.log')
os.chmod(log_file, 0o775)
formatter = Formatter('%(asctime)s:%(levelname)s:%(module)s:%(funcName)s:%(lineno)d:%(message)s', 
                              datefmt=fh_time_format)
handler = RotatingFileHandler(log_file, maxBytes=10000, backupCount=1)
handler.setLevel(logging.INFO)
handler.setFormatter(formatter)
consoleHandler = logging.StreamHandler()
consoleHandler.setLevel(logging.INFO)
consoleHandler.setFormatter(formatter)
app.logger.handlers=[]
app.logger.addHandler(handler)
app.logger.addHandler(consoleHandler)
```

The same log initialization in `R language`:

```r
library(logging)
removeHandler("writeToFile")
basicConfig()
log_file<-str_c(basename(getwd()), ".log", sep='')
addHandler(writeToFile, logger="", file=log_file)
loginfo("started", logger="rnews")
```

# Continuous Integration and Continuous Deployment

To implement Continuous Integration and Continuous Deployment methodology install Jenkins and its plugins: [Blue Ocean](https://jenkins.io/projects/blueocean/), [Email-ext](https://wiki.jenkins.io/display/JENKINS/Email-ext+plugin),
[JUnit](https://wiki.jenkins.io/display/JENKINS/JUnit+Plugin), [Credentials](https://wiki.jenkins.io/display/JENKINS/Credentials+Plugin) on your computer. 

Create jenkins pipeline job. Provide jenkins with your credentials: `USER=<your user name>`, SSH keys to access Github, [configure email notification in Jenkins](https://www.360logica.com/blog/email-notification-in-jenkins/).

Then go to created pipeline job (job must have the same as project name), Configure, go to pipeline tab. Set Definition to Pipeline script from SCM, set repository URL, choose your github credentials, branch `master`, script path `jenkins/Jenkinsfile`.

Run the job. You can see detailed test result in Blue Ocean tab.
  
  

