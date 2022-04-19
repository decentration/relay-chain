#!/usr/bin/env bash

curl -H 'Content-Type: application/json' --data '{ "jsonrpc":"2.0", "method":"author_rotateKeys", "id":1 }' http://127.0.0.1:9934