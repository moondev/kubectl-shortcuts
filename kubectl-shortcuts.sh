#!/usr/bin/env bash

#reset function


k(){

    #args to concatenate
    ARGS=()

    OPTS=

    NS='--all-namespaces'

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
            if [[ "$1" == "f" ]]
            then
            OPTS+=('-f')
            OPTS+=("$2")
            fi

            #kubectl delete pod
            if [[ "$1" == "p" ]]
            then
            OPTS+=('pod')
            OPTS+=("$2")
            fi

            #kubectl delete service
            if [[ "$1" == "s" ]]
            then
            OPTS+=('service')
            OPTS+=("$2")
            fi

        fi

        #kubectl port-forward PODNAME PORT
        if [[ "$1" == "pf" ]]
        then
        OPTS+=("port-forward")
        OPTS+=("$2")
        OPTS+=(":$3")
        OPTS+=("&")
        fi

        #kubectl run NAME --image IMAGE
        #k r nginx nginx:latest 8
        if [[ "$1" == "r" ]]
        then
        OPTS+=("run")
        OPTS+=("$2")
        OPTS+=("--image")
        OPTS+=("$3")
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



    kubectl $OPTS
    echo "kubectl $OPTS"
}

