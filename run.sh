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

log "Downloading operators Manifests"

./get-operator.sh redhat-operators local-storage-operator
./get-operator.sh redhat-operators sriov-network-operator

for f in *.tar.gz; do tar -C manifests/ -xvf $f ; done && rm -rf *tar.gz

log "Creating necessary file for last configuration"

cp registries.sample registries.conf 
cp mirrored-registry.sample  mirrored-registry.yaml 
cp internal-mirrored-operatorhub-catalog.sample  internal-mirrored-operatorhub-catalog.yaml 

log "replace content of sample files"

sed -i "s/YOUR_REGISTRY_URL/${REGISTRY}/g" registries.conf
BASE64_REGS=`cat registries.conf | base64`
sed -i "s/YOUR_FILE_CONTENT_IN_BASE64/$BASE64_REGS/g" mirrored-registry.yaml 
sed -i "s/MY_REGISTRY/$REGISTRY/g" internal-mirrored-operatorhub-catalog.yaml

log "Mirroring operator images"
./mirror-images.sh $REGISTRY
log "Build the operator catalog image"
./build-operator-catalog.sh $REGISTRY

log "DONE"
