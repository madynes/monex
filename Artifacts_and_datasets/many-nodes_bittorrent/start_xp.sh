set -e
curl -X POST "$1/exp/peerxp"
(sleep 2s && ssh -o StrictHostKeyChecking=no root@peer-vadm cp file peer/ && ssh -o StrictHostKeyChecking=no root@peer-vadm transmission-remote 127.0.0.1 -t 1 -v) &
ruby starting.rb&
