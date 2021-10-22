#!/bin/bash
set -ue

#get's all the pods in the namespace and tells you which node it's running on

kubectl get po -o json | jq '.items[].spec.nodeName'
