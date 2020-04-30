#!/bin/bash

DATE=$(date +%Y-%m-%d-%H:%M:%S)

function log(){
    echo "$DATE INFO $@"
    return 0
}

function panic(){
    echo "$DATE ERROR $@"
    exit 1
}

if [ $# -lt 1 ]; then
    panic  "Usage: $0 Registry URL"
fi

REGISTRY=$1

images=(
 openshift4/ose-local-storage-diskmaker:4.3.13
 openshift4/ose-local-storage-static-provisioner:4.3.13
 openshift4/ose-local-storage-operator:4.3.13
 openshift4/ose-sriov-cni:4.3.13
 openshift4/ose-sriov-dp-admission-controller:4.3.13
 openshift4/ose-sriov-network-config-daemon:4.3.13
 openshift4/ose-sriov-network-device-plugin:4.3.13
 openshift4/ose-sriov-network-operator:4.3.13
 openshift4/ose-sriov-network-webhook:4.3.13
 openshift4/ose-sriov-network-operator:4.3.13
)

for image in ${images[@]}; do
	src=$image
	dst=${REGISTRY}/${image#*/}
	skopeo copy --format=v2s2 docker://$src docker://$dst
	#skopeo copy --format=v2s2 docker://$src dir:./container-images
done
