# MonEx
MonEX (for long: **_Mon_**itoring **_Ex_**periments) is an integrated experiment monitoring framework. It fully integrates into the experiment workflow by encompassing all steps from data acquisition to producing publication-quality figures for each part of an experiment campaign. MonEx is based on recent infrastructure monitoring tools (*Prometheus* and *InfluxDB*) to support the various monitoring approaches of experiments.


## Dependencies
- python3
- python3-flask
- python3-requests
- python3-flask-cors
- R with lattice

This should do the trick on Debian:
```
apt install python3-pip python3-flask python3-requests r-base
pip3 install flask-cors
```
## First steps
You can start by doing this [tutorial example](examples/simple_example/).

### Starting monex-server
To start the monex-server, you will need a configuration file with the targets from where to get metrics. For example, if we want to listen for a Prometheus server on the port 9090 of the localhost, the configuration file will look lke that:
```
{"targets":[
  {"server":"prom", "type":"prometheus", "address":"127.0.0.1:9090"}
  ]}
```
By default, monex-server listen on port 5000.
### Start and end experiments
To start or end experiments, we send a POST or PUT request to monex-server at exp/\<XP\_NAME\>. For example, to start an expriment called "myexp" with monex-server running on the port 5000 of the localhost, we can ues the curl command:
```
curl -X POST 127.1:5000/exp/myexp
```
### Getting metrics
To get metrics, we send a GET request with json data to the same url. The json data contain the target server and the metric that we want. The way to get the metric depend of the target use (Prometheus or InfluxDB). For example, if we want to get the cpu usage metric from a prometheus target, we can use the curl command:
```
curl -X GET 127.1:5000/exp/myexp -H "Content-Type: application/json" -d '{"query":"irate(node_cpu[4s])", "server":"prom"}' > metric.csv
```

### Drawing metrics
The monex-draw tool can be use to draw metrics from a csv file. For example to draw from a metric.csv file, we can use:
```
monex-draw -F metric.csv -x 'my x label' -y 'my y label' -t 'my title'
```

You can find the complete documentation of monex-server [here](doc/monex-server.txt).

## Reproducing the use case experiments
if you are looking to reproduce the experiments that are listed in the MonEX paper, you can find their datasets [here](Artifacts_and_datasets). You should refer to the 
[artifact file](Artifacts_and_datasets/artifacts.pdf), which contains a step-by-step tutorial to reproduce them. 

