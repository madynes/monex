# monex
MONitoring EXperiment

## Dependencies
- python3
- python3-flask
- python3-requests
- python3-flask-cors
- R

This should do the trick on debian:
```
apt install python3-pip python3-flask python3-requests r-base
pip3 install flask-cors
```
## First steps
### Starting monex-server
To start the monex-server, you will need a configuration file with targets from where to get metrics. For example, if we want to listen for a Prometheus on the port 9090 of the localhost, the configuration file will be as follow:
```
{"targets":[
  {"server":"prom", "type":"prometheus", "address":"127.0.0.1:9090"}
  ]}
```
By default, monex-server listen on port 5000.
### Start and end experiment
To start or end experiment, we send json data with the name of the experiment to monex-server at /start\_exp or stop\_exp. For example, to start an expriment called "myexp" with monex-server running on the port 5000 of the localhost, we can ues the curl command:
```
curl 127.0.0.1:5000/start_exp -H "Content-Type: application/json" -d '{"name":"myxp"}
```
### Getting metrics
To get metrics, we send json data with the name of the experiment to monex-server at /get\_exp, the target and the metric that we want to get. The way to get the metric depend of the target use (Prometheus or InfluxDB). For example, if we want to get the cpu usage metric from a prometheus target, we can use the curl command:
```
curl 127.1:5000/get_exp -H "Content-Type: application/json" -d '{"name":"myxp","query":"irate(cpu[4s])", "server":"prom"}'
```
The server return data as csv (semi-colon separated value to be exact).
### Drawing metrics
The monex-draw tool can be use to draw metric from a csv file. For example to draw from a metric.csv file, we can use:
```
monex-draw -f metric.csv -x 'my x label' -y 'my y label' -t 'my title'
```
