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
## Starting the experiment
To start the experiment, we just need to send a message to the monex-server. We can use a script to manage that. start\_xp.sh does just that, it start the experiment, launch stress and at the end stop the experiment. So from the experiment node, lauch the script with the address of the monitoring node:
```
sh start_xp.sh ip_monitoring_node:port_monitoring_node
```
