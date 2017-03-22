#!/usr/bin/env bash

set -e

#args to concatenate
ARGS=()

OPTS=
ROLLOUT=

NS='--all-namespaces'

RETVAL=

die() { echo "$@" 1>&2 ; exit 1; }

#service to podid
s2p() {
svc="$1"

label=`kubectl get service $svc --output=json | jq -j '.spec.selector | to_entries | .[] | "\(.key)=\(.value)"'`
podid=`kubectl get pods --selector=$label --output=jsonpath={.items..metadata.name}`

#echo "$podid"
}

#kubectl cluster-info
if [[ "$1" == "ci" ]]
then
OPTS+=('cluster-info')
fi

#kubectl get
if [[ "$1" == "g" ]]
then
OPTS+=('get')

    #kubectl get pods
    if [[ "$2" == "p" ]]
    then
    OPTS+=('pods')
    OPTS+=("$NS")
    fi

    #kubectl get services
    if [[ "$2" == "s" ]]
    then
    OPTS+=('services')
    OPTS+=("$NS")
    fi

    #kubectl get deployments
    if [[ "$2" == "d" ]]
    then
    OPTS+=('deployments')
    OPTS+=("$NS")
    fi

    #kubectl get ingress
    if [[ "$2" == "i" ]]
    then
    OPTS+=('ing')
    OPTS+=("$NS")
    fi

fi

#kubectl apply -f $2
if [[ "$1" == "a" ]]
then
OPTS+=('apply')
OPTS+=('-f')
OPTS+=("$2")
fi

#kubectl delete
if [[ "$1" == "d" ]]
then
OPTS+=('delete')

    #kubectl delete -f
    if [[ "$2" == "f" ]]
    then
    OPTS+=('-f')
    OPTS+=("$3")
    fi

    #kubectl delete pod
    if [[ "$2" == "p" ]]
    then
    OPTS+=('pod')
    OPTS+=("$3")
    fi

    #kubectl delete service
    if [[ "$2" == "s" ]]
    then
    OPTS+=('service')
    OPTS+=("$3")
    fi

    #kubectl delete deployment
    if [[ "$2" == "d" ]]
    then
    OPTS+=('deployment')
    OPTS+=("$3")
    fi

fi

#kubectl port-forward PODNAME PORT
if [[ "$1" == "pf" ]]
then
OPTS+=("port-forward")
OPTS+=("$2")
OPTS+=(":$3")
fi

#kubectl run NAME --image IMAGE
#k r nginx nginx:latest 8
if [[ "$1" == "r" ]]
then
OPTS+=("run")
OPTS+=("$2")
OPTS+=("--image")
OPTS+=("$3")
ROLLOUT="kubectl rollout status deployment/$2"
fi

#kubectl expose deployment/NAME --type NodePort --port PORT
#k e nginx 80
if [[ "$1" == "ep" ]]
then
OPTS+=("expose")
OPTS+=("deployment/$2")
OPTS+=("--type")
OPTS+=("NodePort")
OPTS+=("--port")
OPTS+=($3)
fi

#kubectl expose deployment/NAME --type NodePort --port PORT
#k e nginx 80
if [[ "$1" == "ex" ]]
then
OPTS+=("exec")
OPTS+=("-it")
OPTS+=("$2")
OPTS+=("bash")
fi

#kubectl update
#k update
if [[ "$1" == "update" ]]
then
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl; sudo mv ./kubectl /usr/local/bin/kubectl
fi

#port forward to a service
if [[ "$1" == "s2p" ]]
then
pid=`s2p $2`

OPTS+=("port-forward")
OPTS+=("$pid")
OPTS+=(":$3")

fi

#kubectl $OPTS
echo "kubectl $OPTS"
#sleep 2
#eval $ROLLOUT

