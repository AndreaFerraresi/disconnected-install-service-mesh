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
openshift4/ose-local-storage-static-provisioner@sha256:d62db5115bc21946b14ba5e72aafb17b4c548f00c2678a21c968ae8c0b4465a1
openshift4/ose-local-storage-operator@sha256:3c6db8cab0355258fb1d2e8cc384a8cde5edbd57d9b30ab8e9a4a048fe2c79ab
openshift4/ose-sriov-cni@sha256:53aed34e27067fd542b559a6cc10bbc6d9732b5ca10fb8826029591f6b283cf9
openshift4/ose-sriov-dp-admission-controller@sha256:5e410d0c43963135864496be40bcdf1d24c87a8d03ceb4c93f6be128582bd66c
openshift4/ose-sriov-network-config-daemon@sha256:3c23167ac70a5b31da979207dc02a4ef71a811cc26c9103d206390d124ec9260
openshift4/ose-sriov-network-device-plugin@sha256:862234fe5b5b422a7760b28e9a0a51442be41bad49c6f6769b19dc73d9b7cd7c
openshift4/ose-sriov-network-operator@sha256:10efeae479a3476a232ff9fff2089e199811e0116811e5f67df3e6bb67b7913a
openshift4/ose-sriov-network-webhook@sha256:deb09e57f32c28fc4446771cee6414f3ef59b9659907ded793a8bd52219c4a77
openshift4/ose-sriov-network-operator@sha256:10efeae479a3476a232ff9fff2089e199811e0116811e5f67df3e6bb67b7913a
)

for image in ${images[@]}; do
	src=$image
	dst=${REGISTRY}/${image#*/}
	skopeo copy --format=v2s2 docker://registry.redhat.io/$src docker://$dst
	#skopeo copy --format=v2s2 docker://$src dir:./container-images
done

