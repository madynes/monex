# MonEx
MONitoring EXperiment

## Dependencies
- python3
- python3-flask
- python3-requests
- python3-flask-cors
- R

This should do the trick on Debian:
```
apt install python3-pip python3-flask python3-requests r-base
pip3 install flask-cors
```
## First steps
You can start by doing the [tutorial](examples/simple_example/).
### Starting monex-server
To start the monex-server, you will need a configuration file with the targets from where to get metrics. For example, if we want to listen for a Prometheus server on the port 9090 of the localhost, the configuration file will look lke that:
```
{"targets":[
  {"server":"prom", "type":"prometheus", "address":"127.0.0.1:9090"}
  ]}
```
By default, monex-server listen on port 5000.
### Start and end experiments
To start or end experiments, we send json data with the name of the experiment to monex-server at /start\_exp or stop\_exp. For example, to start an expriment called "myexp" with monex-server running on the port 5000 of the localhost, we can ues the curl command:
```
curl 127.1:5000/start_exp -H "Content-Type: application/json" -d '{"name":"myxp"}
```
### Getting metrics
To get metrics, we send json data with the name of the experiment, the target server and the metric that we want to get to monex-server at /get\_exp. The way to get the metric depend of the target use (Prometheus or InfluxDB). For example, if we want to get the cpu usage metric from a prometheus target, we can use the curl command:
```
curl 127.1:5000/get_exp -H "Content-Type: application/json" -d '{"name":"myxp","query":"irate(node_cpu[4s])", "server":"prom"}' > metric.csv
```
The server return data as semi-colon separated value (almost csv).
### Drawing metrics
The monex-draw tool can be use to draw metrics from a csv file. For example to draw from a metric.csv file, we can use:
```
monex-draw -f metric.csv -x 'my x label' -y 'my y label' -t 'my title'
```

You can find the complete documentation of monex-server [here](doc/monex-server.txt).
