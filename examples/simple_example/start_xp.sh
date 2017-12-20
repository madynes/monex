curl -X POST "$1/exp/stress"
sleep 2
stress --cpu 4 --timeout 10s
sleep 6
curl -X PUT "$1/exp/stress"

