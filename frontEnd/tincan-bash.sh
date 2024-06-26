#!/bin/bash


echo "Container: Started docker container"

ipAddr="localhost:8080"
function readMessage() {
    read -p "message: " message
    curl -v -G "$ipAddr/http/send" \
        --data-urlencode "message=$message" \
        --data-urlencode "user=$name"
}

curl -v $ipAddr

httpOptions=("http" "h" "htt" "htp")
websocketOptions=("websocket" "ws" "websockey" "web" "websock" "wscat")

read -p "http or websocket? " httpWebsocket
#if [ $httpWebsocket = "http" ]; then
if [[ ${httpOptions[@]} =~ $httpWebsocket ]]; then
    read -p "send or receive? " sendReceive
    if [ $sendReceive = "send" ]; then
        read -p "name: " name
        message="enter"
        curl -v -G "$ipAddr/http/send" \
            --data-urlencode "message=$message" \
            --data-urlencode "user=$name"
        while [[ $message != "exit" ]]; do
            readMessage
        done
    elif [ $sendReceive = "receive" ]; then
        watch -n 3 curl "$ipAddr/http/receive"
    else
        echo "unrecognised input"
    fi
#elif [ $httpWebsocket = "websocket" ]; then
elif [[ ${websocketOptions[@]} =~ $httpWebsocket ]]; then
    wscat -c "ws://$ipAddr/ws" \
        --header "Connection: Upgrade" \
        --header "Upgrade: websocket" \
        --header "Host: $ipAddr" \
        --header "Sec-WebSocker-Key: SGVsbG8sIHdvcmxk" \
        --header "Sec-WebSocket-Version: 13"
else
    echo "unrecognised input"
fi

echo "Container: Exiting docker container"
