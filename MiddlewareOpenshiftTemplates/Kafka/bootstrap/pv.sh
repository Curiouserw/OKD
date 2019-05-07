#!/bin/bash

echo "Creating persistant volume using hostPath volumes in the current Dir"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
path="$dir/data"
cat bootstrap/pv-template.yml | sed "s|/tmp/k8s-data|$path|" | kubectl create -f -
