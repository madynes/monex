curl "$1/start_exp" -H "Content-Type: application/json" -d '{"name":"stress"}'
sleep 2
stress --cpu 4 --timeout 10s
sleep 6
curl "$1/stop_exp" -H "Content-Type: application/json" -d '{"name":"stress"}'

