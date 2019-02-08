# nginx-flask-plumber
Python flask and R plumber servers that run under the reverse proxy nginx.

This is small web services package intended for demonstration purposes only. The nginx-flask-plumber project shows Continuous Integration and Continuous Deployment software development methodology on the basis of docker containers and jenkins automation server as continuos integration tool. 

Project runs two web services which exchange messages and payloads between each other through HTTP API calls in RESTful software architectural style.

pnews web service is written in python and implements Flask microframework. It can send and recieve GET and POST web requests and manipulate web browser through selenium library. 

rnews web service is written i R language and implements Plumber package web API functionality that is syntactically similar to Python Flask.

Both services use similar logging packages from R and Python respectively. All API calls are reflected in log file.

In this example web services can perform health check, respond to echo requests, exchange data frames in text form. Payload in POST requests is coded in json format, data frames and time series variables is converted to csv text memory files and then packaged in json.

jenkins file describe all the Continuous Integration and Continuous Deployment pipeline. It checkouts repository from Github, builds new docker images, runs containers (which will be recreated if were running), perform functional tests such as health check or connectivity between web services, collect junit reports and send email to the user in case of successfull finish.


