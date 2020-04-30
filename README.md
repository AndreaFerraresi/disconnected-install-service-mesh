# Disconnected SR-IOV operator and Local Storage operator install

## Disable the default OperatorSources from the bastion host

```
$ oc patch OperatorHub cluster --type json \
    -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
```

### Clone the needed software to the target registry from the connected host

```
export REGISTRY=myregistry.bastion.mynetwork:5000
$ ./run.sh
```

### Then, apply the config file 

```
oc apply -f mirrored-registry.yaml
```

## Apply the CatalogSource

```
oc create -f internal-mirrored-operatorhub-catalog.yaml
```

## Check status

```
oc get pods -n openshift-marketplace
oc get catalogsource -n openshift-marketplace
oc describe catalogsource internal-mirrored-operatorhub-catalog -n openshift-marketplace
```