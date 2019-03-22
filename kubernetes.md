# Kubernetes

```bash
# get the available jobs and pods
kubectl get jobs
kubectl get pods


# get/use context (cluster). This is used for switching between clusters.
kubectl config get-contexts
kubectl config use-context <CONTEXT_NAME>
# one context can have multiple namespaces. 
# get the namespaces for the current context
kubectl get namespaces
# one can set the default namespace for a certain context
kubectl config set-context $(kubectl config current-context) --namespace=NAMESPACE


# get the available configmaps
kubectl get configmaps
# get the details of one configmap in yaml format (-o json to get it in json format)
kubectl get configmaps CONFIG_MAP -o yaml
# extract a field from a config map (requires jq)
MY_VAR=$(kubectl get configmaps CONGIF_MAP -o json | jq -r .field1.field2.field2)


# run command inside a pod (create and run a new job)
kubectl exec POD_NAME -- command
# delete a job
kubectl get jobs
kubectl delete jobs JOB_NAME


# enter into a kubernetes pod available as a docker
kubectl get pods
kubectl exec -it POD_NAME /bin/bash


# get the logs of a kubernetes pod
kubectl get pods
kubectl logs POD_NAME



# kubernetes "filesystem" operations
# copy a file from local fs to kubernetes
$POD=$(kubectl get pods -l app=POD_NAME_PATTERN --no-headers -o custom-columns=":metadata.name")
$DIR=$(kubectl get pv PERMANENT_VOLUME -o json | jq -r .field1.field2.field3)
kubectl cp example.vcf $POD:$DIR


# get details about nodes 
kubectl describe nodes


# get details about a pod. This gives details about pod history etc.
kubectle describe pods POD_NAME


# To update a deployment with the latest (dev) docker image: 
# 1. go to CircleCI and click on "test_and_build"
# 2. go to 'release_image' and copy the docker image at the end
# 3. run `kubectl edit deployments DEPLOYMENT_NAME` (this opens a Vim screen)
# 4. paste the docker image in the file and save (the pod will update automatically)


# misc get commands
kubectl get events | pods | jobs | services | deployments | network
```

