#!/bin/bash
function log(){
    echo "$DATE INFO $@"
    return 0
}

function panic(){
    echo "$DATE ERROR $@"
    exit 1
}

#if [[ ! -f "auth.json" ]]; then
#    panic "Missing auth.json, please download pull secret and save it as auth.json in `echo $PWD`"
#fi

if [[ ! -d "manifests" ]]; then
    log "Creating manifests direcory"
    mkdir manifests
fi

log "Downloading Manifests"

./get-operator.sh redhat-operators local-storage-operator
./get-operator.sh redhat-operators sriov-network-operator

for f in *.tar.gz; do tar -C manifests/ -xvf $f ; done && rm -rf *tar.gz

./mirror-images.sh $REGISTRY
./build-operator-catalog.sh $REGISTRY

