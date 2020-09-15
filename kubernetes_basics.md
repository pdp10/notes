# Learn Kubernetes Basics
Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/ 

With modern web services, users expect applications to be available 24/7, and developers expect to deploy new versions of those applications several times a day. Containerization helps package software to serve these goals, enabling applications to be released and updated in an easy and fast way without downtime. Kubernetes helps you make sure those containerized applications run where and when you want, and helps them find the resources and tools they need to work. Kubernetes is a production-ready, open source platform designed with Google's accumulated experience in container orchestration, combined with best-of-breed ideas from the community.



### Installation

- install a hypervisor (e.g. install virtualbox)
- install minikube (see: https://github.com/kubernetes/minikube/releases)
- install kubectl (see: https://kubernetes.io/docs/tasks/tools/install-kubectl/)



### Creating a cluster

Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/ 

To get started with Kubernetes development, you can use Minikube. Minikube is a lightweight Kubernetes implementation that creates a VM on your local machine and deploys a simple cluster containing only one node.

Basic commands:
```
# get the minikube version
minikube version

# start the minikube cluster
minikube start 

# get the version for Kubernetes command line interface
kubectl version

# get kubectl cluster information
kubectl cluster-info

# get the nodes in the cluster
kubectl get nodes
```


### Kubernetes Deployments

Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/ 

Once you have a running Kubernetes cluster, you can deploy your containerized applications on top of it. Once the application instances are created, a Kubernetes Deployment Controller continuously monitors those instances. If the Node hosting an instance goes down or is deleted, the Deployment controller replaces it. This provides a self-healing mechanism to address machine failure or maintenance.

You can create and manage a Deployment by using the Kubernetes command line interface, Kubectl. Kubectl uses the Kubernetes API to interact with the cluster. The common format of a kubectl command is: kubectl action resource. The run command creates a new deployment.

##### Deployments
```
# Let’s run our first app on Kubernetes with the kubectl run command.
# We need to provide the deployment name and app image location.
kubectl run kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --port=8080

# To list your deployments use the get deployments command:
kubectl get deployments
```

##### Pods, proxy, pod endpoint
```
# Pods that are running inside Kubernetes are running on a private, isolated network.
# The kubectl command can create a proxy that will forward communications into the 
# cluster-wide, private network. The proxy can be terminated by pressing control-C 
# and won't show any output while its running. We will open a SECOND TERMINAL WINDOW 
# to run the proxy.
kubectl proxy

# On the first window, you can see all those APIs hosted through the proxy endpoint, 
# now available at through http://localhost:8001. For example, we can query the 
# version directly through the API using the curl command:
curl http://localhost:8001/version

# The API server will automatically create an endpoint for each pod, 
# based on the pod name, that is also accessible through the proxy.
# First we need to get the Pod name, and we'll store in the environment variable POD_NAME:
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# Now we can make an HTTP request to the application running in that pod:
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
```


### Kubernetes Pods

Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/

##### Pods
When you created a Deployment in Module 2, Kubernetes created a Pod to host your application instance. A Pod is a Kubernetes abstraction that represents a group of one or more application containers (such as Docker or rkt), and some shared resources for those containers. Those resources include:

- Shared storage, as Volumes
- Networking, as a unique cluster IP address
- Information about how to run each container, such as the container image version or specific ports to use

Important points:

- A Pod models an application-specific "logical host" and can contain different application containers which are relatively tightly coupled.
- Pods run in an isolated, private network - so we need to proxy access to them so we can debug and interact with them. 
- The containers in a Pod share an IP Address and port space, are always co-located and co-scheduled, and run in a shared context on the same Node. Precisely: 1 Pod has 1 IP number; each container within a Pod has its own port.
- Pods are the atomic unit on the Kubernetes platform. When we create a Deployment on Kubernetes, that Deployment creates Pods with containers inside them (as opposed to creating containers directly).
- **Containers should only be scheduled together in a single Pod if they are tightly coupled and need to share resources such as disk.**


##### Nodes
A Pod always runs on a Node. A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster. Each Node is managed by the Master. A Node can have multiple pods, and the Kubernetes master automatically handles scheduling the pods across the Nodes in the cluster. Every Kubernetes Node runs at least:

- Kubelet, a process responsible for communication between the Kubernetes Master and the Node; it manages the Pods and the containers running on a machine.
- A container runtime (like Docker, rkt) responsible for pulling the container image from a registry, unpacking the container, and running the application.

See: https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg 

The most common operations (e.g. when applications were deployed, what their current statuses are, where they are running and what their configurations are.) can be done with the following kubectl commands:

- kubectl get - list resources
- kubectl describe - show detailed information about a resource
- kubectl logs - print the logs from a container in a pod
- kubectl exec - execute a command on a container in a pod


```
# get existing Pods and show their status
kubectl get pods

# to view what containers are inside that Pod and what images are used to build 
# those containers we run the describe pods command:
kubectl describe pods

# Start the proxy to communicate with the Pods:
kubectl proxy

# Get the Pod name
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# To see the output of our application, run a curl request.
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

# Anything that the application would normally send to STDOUT becomes logs for the
# container within the Pod. Note: We don’t need to specify the container name, 
# because we only have one container inside the pod. 
# We can retrieve these logs using the kubectl logs command:
kubectl logs $POD_NAME

```

Executing commands on the container.
```
# We can execute commands directly on the container once the Pod is up and running. 
kubectl exec $POD_NAME env

# Next let’s start a bash session in the Pod’s container:
kubectl exec -ti $POD_NAME bash

# We have now an open console on the container where we run our NodeJS application. 
# The source code of the app is in the server.js file:
cat server.js

# You can check that the application is up by running a curl command.
# Note: here we used localhost because we executed the command inside the NodeJS container
curl localhost:8080

# To close your container connection type exit.
exit

```


### Using a Service to Expose Your App

Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/ 
See: https://d33wubrfki0l68.cloudfront.net/b964c59cdc1979dd4e1904c25f43745564ef6bee/f3351/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg

Kubernetes Pods are mortal. Pods in fact have a lifecycle. When a worker node dies, the Pods running on the Node are also lost. A ReplicationController might then dynamically drive the cluster back to desired state via creation of new Pods to keep your application running. As another example, consider an image-processing backend with 3 replicas. Those replicas are fungible; the front-end system should not care about backend replicas or even if a Pod is lost and recreated. That said, each Pod in a Kubernetes cluster has a unique IP address, even Pods on the same Node, so there needs to be a way of automatically reconciling changes among Pods so that your applications continue to function.

- A Kubernetes Service is an abstraction layer which defines a logical set of Pods and a policy by which to access them. A Service enables external traffic exposure, load balancing and service discovery for those Pods.
- Services enable a loose coupling between dependent Pods. 
- A Service is defined using YAML (preferred) or JSON, like all Kubernetes objects. 
- The set of Pods targeted by a Service is usually determined by a LabelSelector (see below for why you might want a Service without including selector in the spec).

Although each Pod has a unique IP address, those IPs are not exposed outside the cluster without a Service. Services allow your applications to receive traffic. Services can be exposed in different ways by specifying a type in the ServiceSpec:

- ClusterIP (default) - Exposes the Service on an internal IP in the cluster. This type makes the Service only reachable from within the cluster.
- NodePort - Exposes the Service on the same port of each selected Node in the cluster using NAT. Makes a Service accessible from outside the cluster using <NodeIP>:<NodePort>. Superset of ClusterIP.
- LoadBalancer - Creates an external load balancer in the current cloud (if supported) and assigns a fixed, external IP to the Service. Superset of NodePort.
- ExternalName - Exposes the Service using an arbitrary name (specified by externalName in the spec) by returning a CNAME record with the name. No proxy is used. This type requires v1.7 or higher of kube-dns.

** A Service routes traffic across a set of Pods. Services are the abstraction that allow pods to die and replicate in Kubernetes without impacting your application. Discovery and routing among dependent Pods (such as the frontend and backend components in an application) is handled by Kubernetes Services.**

##### Expose
```
# Let’s verify that our application is running.
kubectl get pods

# Let’s list the current Services from our cluster. 
# A Service called kubernetes is created by default when minikube starts the cluster
kubectl get services

# To create a new service and expose it to external traffic we’ll use the 
# expose command with NodePort as parameter (minikube does not support the 
# LoadBalancer option yet).
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

# Let’s run again the get services command:
kubectl get services

# To find out what port was opened externally (by the NodePort option) 
# we’ll run the describe service command:
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has the value of the 
# Node port assigned:
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# Now we can test that the app is exposed outside of the cluster using curl, 
# the IP of the Node and the externally exposed port:
curl $(minikube ip):$NODE_PORT

# And we get a response from the server. The Service is exposed.
```

##### Labels

```
# The Deployment created automatically a label for our Pod. 
# With describe deployment command you can see the name of the label:
kubectl describe deployment

# Let’s use this label to query our list of Pods. We’ll use the kubectl 
# get pods command with -l as a parameter, followed by the label values:
kubectl get pods -l run=kubernetes-bootcamp

# You can do the same to list the existing services:
kubectl get services -l run=kubernetes-bootcamp

# Get the name of the Pod and store it in the POD_NAME environment variable:
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# To apply a new label we use the label (v1) command followed by the object type, 
# object name and the new label:
kubectl label pod $POD_NAME app=v1

# This will apply a new label to our Pod (we pinned the application version to the Pod),
# and we can check it with the describe pod command:
kubectl describe pods $POD_NAME

# We see here that the label is attached now to our Pod. And we can query now 
# the list of pods using the new label:
kubectl get pods -l app=v1

```

##### Deleting a service
```
# To delete Services you can use the delete service command. Labels can be used also here:
kubectl delete service -l run=kubernetes-bootcamp

# Confirm that the service is gone:
kubectl get services

# This confirms that our Service was removed. To confirm that route is not exposed 
# anymore you can curl the previously exposed IP and port:
curl $(minikube ip):$NODE_PORT

# This proves that the app is not reachable anymore from outside of the cluster. 
# You can confirm that the app is still running with a curl inside the pod:
kubectl exec -ti $POD_NAME curl localhost:8080

We see here that the application is up.
```

### Running Multiple Instances of Your App
Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-intro/

In the previous modules we created a Deployment, and then exposed it publicly via a Service. The Deployment created only one Pod for running our application. When traffic increases, we will need to scale the application to keep up with user demand. **Scaling** is accomplished by changing the number of replicas in a Deployment.

**Scaling is accomplished by changing the number of replicas in a Deployment.**

See: https://d33wubrfki0l68.cloudfront.net/30f75140a581110443397192d70a4cdb37df7bfc/b5f56/docs/tutorials/kubernetes-basics/public/images/module_05_scaling2.svg 

Scaling out a Deployment will ensure new Pods are created and scheduled to Nodes with available resources. Scaling will increase the number of Pods to the new desired state. Kubernetes also supports autoscaling of Pods, but it is outside of the scope of this tutorial. Scaling to zero is also possible, and it will terminate all Pods of the specified Deployment.

Running multiple instances of an application will require a way to distribute the traffic to all of them. Services have an integrated load-balancer that will distribute network traffic to all Pods of an exposed Deployment. Services will monitor continuously the running Pods using endpoints, to ensure the traffic is sent only to available Pods.

Once you have multiple instances of an Application running, you would be able to do Rolling updates without downtime. We'll cover that in the next module. Now, let's go to the online terminal and scale our application.

##### Scaling up
```
# To list your deployments use the get deployments command: 
kubectl get deployments

# We should have 1 Pod. If not, run the command again. This shows:
# The DESIRED state is showing the configured number of replicas
# The CURRENT state show how many replicas are running now
# The UP-TO-DATE is the number of replicas that were updated to match the desired (configured) state
# The AVAILABLE state shows how many replicas are actually AVAILABLE to the users
# 
# Next, let’s scale the Deployment to 4 replicas. We’ll use the kubectl scale command, followed by the deployment type, name and desired number of instances:
kubectl scale deployments/kubernetes-bootcamp --replicas=4

# To list your Deployments once again, use get deployments:
kubectl get deployments

# The change was applied, and we have 4 instances of the application available. Next, let’s check if the number of Pods changed:
kubectl get pods -o wide

# There are 4 Pods now, with different IP addresses. The change was registered in the Deployment events log. To check that, use the describe command:
kubectl describe deployments/kubernetes-bootcamp

# You can also view in the output of this command that there are 4 replicas now.

```

##### Load balancing
```
# Let’s check that the Service is load-balancing the traffic. To find out the exposed IP and Port we can use the describe service as we learned in the previously Module:
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has a value as the Node port:
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# Next, we’ll do a curl to the exposed IP and port. Execute the command multiple times:
curl $(minikube ip):$NODE_PORT

# We hit a different Pod with every request. This demonstrates that the load-balancing is working.
```

##### Scaling down
```
# To scale down the Service to 2 replicas, run again the scale command:
kubectl scale deployments/kubernetes-bootcamp --replicas=2

# List the Deployments to check if the change was applied with the get deployments command:
kubectl get deployments

# The number of replicas decreased to 2. List the number of Pods, with get pods:
kubectl get pods -o wide

# This confirms that 2 Pods were terminated.
```


### Performing a Rolling Update (update your App)
Ref: https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/

Users expect applications to be available all the time and developers are expected to deploy new versions of them several times a day. In Kubernetes this is done with rolling updates. Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources.

In the previous module we scaled our application to run multiple instances. This is a requirement for performing updates without affecting application availability. By default, the maximum number of Pods that can be unavailable during the update and the maximum number of new Pods that can be created, is one. Both options can be configured to either numbers or percentages (of Pods). In Kubernetes, updates are versioned and any Deployment update can be reverted to previous (stable) version.

**Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones.**

See: https://d33wubrfki0l68.cloudfront.net/6d8bc1ebb4dc67051242bc828d3ae849dbeedb93/fbfa8/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates4.svg 

Similar to application Scaling, if a Deployment is exposed publicly, the Service will load-balance the traffic only to available Pods during the update. An available Pod is an instance that is available to the users of the application.

Rolling updates allow the following actions:

- Promote an application from one environment to another (via container image updates)
- Rollback to previous versions
- Continuous Integration and Continuous Delivery of applications with zero downtime

##### Update
```
# To list your deployments use the get deployments command: kubectl get deployments
# To list the running Pods use the get pods command:
kubectl get pods

# To view the current image version of the app, run a describe command against the Pods (look at the Image field):
kubectl describe pods

# To update the image of the application to version 2, use the set image command, followed by the deployment name and the new image version:
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

# The command notified the Deployment to use a different image for your app and initiated a rolling update. Check the status of the new Pods, and view the old one terminating with the get pods command:
kubectl get pods
```

##### Verify an update
```
# First, let’s check that the App is running. To find out the exposed IP and Port we can use describe service:
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has the value of the Node port assigned:
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# Next, we’ll do a curl to the the exposed IP and port:
curl $(minikube ip):$NODE_PORT

# We hit a different Pod with every request and we see that all Pods are running the latest version (v2). The update can be confirmed also by running a rollout status command:
kubectl rollout status deployments/kubernetes-bootcamp

# To view the current image version of the app, run a describe command against the Pods:
kubectl describe pods

#We run now version 2 of the app (look at the Image field)
```

##### Rollback an update
```
# Let’s perform another update, and deploy image tagged as v10 :
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10

# Use get deployments to see the status of the deployment:
kubectl get deployments

# And something is wrong… We do not have the desired number of Pods available. List the Pods again:
kubectl get pods

# A describe command on the Pods should give more insights:
kubectl describe pods

# There is no image called v10 in the repository. Let’s roll back to our previously working version. We’ll use the  rollout undo command:
kubectl rollout undo deployments/kubernetes-bootcamp

# The rollout command reverted the deployment to the previous known state (v2 of the image). Updates are versioned and you can revert to any previously know state of a Deployment. List again the Pods:
kubectl get pods

# Four Pods are running. Check again the image deployed on the them:
kubectl describe pods

# We see that the deployment is using a stable version of the app (v2). The Rollback was successful.
```


