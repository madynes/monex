# Simple experiment
Simple example of monex usage with Prometheus.

## Setup
For this experiment, we want to monitor cpu usage. We will use two machines:
- a monitoring node where we will start monex and Prometheus
- an experiment node that we want to monitor

First install monex and prometheus on the monitoring node, on debian:
```
apt install python3-pip python3-flask python3-requests r-base prometheus
pip3 install flask-cors
systemctl stop prometheus
git clone https://github.com/madynes/monex.git
```
Next, on the experiment node, install prometheus-node-exporter, curl and stress:
```
apt install prometheus-node-exporter stress curl
```
By default, prometheus-node-exporter expose metrics to the port 9100.
Edit the configuration file of prometheus prometheus-config.yml with the experiment node address (with port 9100) and start prometheus on the monitoring node.
```
prometheus -config.file prometheus-config.yml
```
Now we have prometheus in place. We only need to configure and start monex.
Since we start monex on the same machine as Prometheus, we have to listen Prometheus on the localhost at port 9090. Check the monex-server.conf and lanch monex-server:
```
./monex-server monex-server.conf
```
The default port for monex is 5000.
## Starting the experiment
To start the experiment, we just need to send a message to the monex-server. We can use a script to manage that. start\_xp.sh does just that, it start an experiment call "stress", stress the cpu and at the end stop the experiment. So from the experiment node, lauch the script with the address of the monitoring node:
```
sh start_xp.sh IP_MONITORING_NODE:MONEX_PORT
```
## Getting the metrics
By default, prometheus-node-exporter exposed the time spend by each core in each mode at "node\_cpu". To get the cpu usage, we have to make a query using prometheus [https://www.robustperception.io/understanding-machine-cpu-usage/]. If we want the usage per core, the query should be:
```
100 - irate(node_cpu{mode="idle"}[5m]) * 100
```
So to get result using monex, we can use this request:
```
curl -H "Content-Type: application/json" IP_MONITORING_NODE:MONEX_PORT \
{"name":"stress", "query":"100 - irate(node_cpu{mode=\"idle\"}[5m]) * 100"} \
"server":"prom","type":"duration","labels":["cpu"]} > mydata.csv
```
We get a csv file with the data of the experiment.
Let's explain the options use here:
- Our Poremetheus Query, note that we have to escape the double comma in the query.
- The server that we define in the monex configuration file
- The type can be "duration" or "timestamp": duration will make our experiment start a time zero. Timestamp ues UNIX timestamp (at UTC time)
- Prometheus add metadata to columns called label, we can use the label as coulumn name: here we precise "cpu" wich is the label identifying each core, so our coulumns lool like "cpu1, cpu2...". We can have multiple labels, in that case the column names will be all of theme separtated by underscores.
## Drawing it
Now that we have our csv file, we can use monex-draw to make a figure. For example using:
```
monex-draw -f mydata.csv -x 'time (sec)' -y 'core usage (%)' -t 'stress benchmark'
```
We can also draw only the first 3 core using the -c option:
```
monex-draw -f mydata.csv -x 'time (sec)' -y 'core usage (%)' -c cpu0,cpu1,cpu2 -t 'stress benchmark'
```