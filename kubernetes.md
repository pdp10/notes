# Kubernetes

### Basic commands

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
# e.g. get docker image from deployment
kubectl -n planet-express-37 get deployments sapientia-web -ojson | jq -r '.spec.template.spec.containers[0].image'



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
# If a pod does not start correctly, run this command.
kubectl describe pods POD_NAME


# To update a deployment with the latest (dev) docker image: 
# 1. go to CircleCI and click on "test_and_build"
# 2. go to 'release_image' and copy the docker image at the end
# 3. kubectl edit deployments DEPLOYMENT_NAME (this opens a Vim screen)
# 4. paste the docker image in the file and save (the pod will update automatically)


# misc get commands
kubectl get events | pods | jobs | services | deployments | network | secrets
```


### USEFUL kubectl/jq commands 
```bash
# get a explanation of a particular resource or field
kubectl explain pods
kubectl explain pv # persistent volumes

# explain what resource limit means in the Job spec
kubectl explain configmap
kubectl explain job.spec.template.spec.containers.resources.limits

# check pipeline configurations with Job-Runner: 
kubectl get configmaps sap-job-config-core -o yaml | less

# list resources (pods, jobs, etc.)
kubectl get pods
kubectl get deployments
kucectl get configmaps

# get only jobs for a particular pipeline or IR
kubectl get jobs -l pipelineName=load_snvs
kubectl get jobs -l interpretationRequestId=7

# get counts of all pipeline types currently running
kubectl get jobs -o json | jq -r .items[].metadata.labels.pipelineName | sort | uniq -c

# see all information about a resource
kubectl describe nodes
kucectl describe deployment sapientia-web

# forward a pod's internal IP to localhost
kubectl port-forward [web-pod] 8000 # then go to http://127.0.0.1:8000 in your browser

# edit a deployment (or configmap, secret, etc.)
kubectl edit deployment web-pod
kubectl edit configmap sap-job-config-performance

# copy a file onto (or off of) a volume via a pod
kubectl cp [file to upload] [pod]:[path]

# base64 encoding/decoding for secrets
echo -n "my_secret" | base64
echo -n "bXlfc2VjcmV0" | base64 --decode

# enter into a running pod to look around and/or execute commands
kubectl exec -it [pod] /bin/bash

# see/follow the logs for a running pod (-f is follow)
kubectl logs [-f] [pod]

# stream all jr pod logs back and filter out job ID "99", sort by timestamp
kubectl exec [jr pod] -- /bin/bash -c "cat /var/log/jr/*/*.log" | jq -s '.[] | select(.sap_job_id == "99")' | jq -s 'sort_by(.timestamp)' | less

# create/delete a pod
kubectl get pods
kubectl create -f piero-pod.yaml
kubectl delete pods piero-pod

# create/delete a job
kubectl get jobs
kubectl create -f simple-job.yaml
kubectl delete jobs simple-job

# enter the jr pod
kubectl exec -it jr-XXX /bin/bash
ls /scratch/JOBID/... 
ls /var/log/jr/job-runner-YYY/pipeline-8-ZZZ/

# enter sapctl pod
kubectl exec -it sapctl-XXX /bin/bash
sapctl service get
sapctl user get

# run an IR: 
kubectl exec -it jr /bin/bash
cd /data/pipeline-ns/pipeline/source/

# get/use context (cluster). This is used for switching between clusters.
kubectl config get-contexts
kubectl config use-context <CONTEXT_NAME>
# one context can have multiple namespaces. 
# get the namespaces for the current context
kubectl get namespaces
# change namespace within the same context
kubectl config set-context --current --namespace=NAMESPACE
# change context and namespace 
kubectl config use-context CONTEXT --namespace=NAMESPACE

# look at jobs running in K8s, displaying job metadata such as pipeline name, IR, etc., as  columns using `-L`  (kjobs)
kubectl get jobs -L pipelineName -L sapientiaJobId -L interpretationRequestId -L projectId -L timestamp -L submitterName
```



### WORKFLOW: Create POD from file
This allows arbitrary checkouts in k8s (without needing a docker rebuild). 
See file: piero-pod.yaml

```bash
# 1. One off. Create your own folder in scratch
kubectl exec -it JR_POD /bin/bash
mkdir /scratch/piero

# 2. Copy your arbitrary local checkout to /scratch in the cluster (NOTE: scratch is shared, therefore it does not have to be job-runner)
kubectl cp /path/to/my/REPO JR_POD:/scratch/piero/REPO

# 3. Create your pod using the yaml file attached here as a template. This uses a recent docker image.
# When your pod starts, it replaces the /app from the docker image with your checkout in scratch, via a symlink.
kubectl create -f piero-pod.yaml

# 4. Attach to your pod, and run stuff (e.g. pipelines) 
kubectl exec -it piero-pod /bin/bash
```


