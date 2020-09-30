Kubernetes
============
Purpose of Kubernetes is to host the application Containers
Kubernetes use docker host to host the application in the form of docker container 

Master -- Node1 Node2 Node3

kubectl Object Management
=========
the kubectl tool supports 3 kind of object management

1) Imperative commnds                   (using cli command to deploy without writing YAML)
2) Imperative object configuration      (writing Yaml and also editing it manually  "kubectl create"  )
3) Declarative object configuration     (its automated   "kubectl apply")

PODs
=========
A Kubernetes pod is a group of containers that are deployed together on the same host. If deploy single containers, we can generally replace the word "pod" with "container" and accurately understand the concept.

A Pod always runs on a Node. A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster. A Node can have multiple pods, and the Kubernetes master automatically handles scheduling the pods across the Nodes in the cluster

NameSpace 
===========
its defines the virtual cluster inside a kubernetes cluster 

By default, a Kubernetes cluster is created

1) default: By default all the resource created in Kubernetes cluster are created in the default namespace. By default the default namespace can allow applications to run with unbounded CPU and memory requests/limits (Until someone set resource quota for the default namespace).

2) kube-public: Namespace for resources that are publicly readable by all users. This namespace is generally reserved for cluster usage.

3) kube-system: It is the Namespace for objects created by Kubernetes systems/control plane.

#kubectl get namespaces
#kubectl get events -n <namespace>

Components of Kubernetes
========================

1) API server -- (acts as the frontend of kubernetes (users, management devices, command line interface))	

2) etcd	--  (a key value store, its an distributed key value store used by kubernetes to store all data which is use to manage cluster)  

3) kubelet service -- (Agent that runs on each node on the cluster, agent is responsible for makinging sure that the containers are running on the nodes as expected )     

4) container runtime -- (is an underline software that is use to run containers)

5) controller --   (controller is the brain behind the orchestration, responsible of noticing and responding when nodes or container endpoint goes down, controllers also make disecions to bring up new containers)

6) Scheduler  --  (responsible for distributing work/container accross multiple nodes looks for newly created container and asing them to nodes)

7) kubectl -- (kube control tool is the kubernets CLI use to deploy and manage applications on a kubernets cluster to get cluster related informations, status od the node in the cluster )

==================================================================================================================================================

Kubernetes Cluster Architechture
==================================
Master Node  
---- 
use to manage the Kubernetes cluster storing information regarding diffrent nodes 

ETCD in kubernetes  (manager)
----
Key Value Store, its a database that stores information in Key value formate. 

Kube-API Server (manager)
----
Its an Primary manegment componenet of kubernetes 
it is responsible of orchestration all the oprations within the cluster, it expose the Kubernetes API which is used by external users to preform management oprations on the cluster as well as the verious controllers to moniter the state of the cluster and make necessry changes as required.
and also worker nodes to communicate with the server. 

Controller Managers  (manager)
----
consiste of Node-Controler and Replication-Controler.
Controller is the brain behind the orchestration, responsible of noticing and responding when nodes or container endpoint goes down, controllers also make disecions to bring up new containers.

Kube Schaduler  (manager)
-----
Responsible for distributing work/container accross multiple nodes depending on the containers resoures requirement the worker node capacity, policies etc.. 

Kubelet  (worker)
----
Its an agent that runs on the each node on a cluster, listens for the instructions from Kube API server and deploys or destroys the containers on the nodes as required, Kuber-API servers featches the status reports from the Kubelet to moniter the status of nodes and containers on them. 

Kube Proxy  (worker)  
----
kube-proxy service insures the necessry rules are in place on the worker nodes to allow the containers running on them to reach eachother.

kube control command (kubectl)
===============================

#kubectl run hello-minikube    //is use to deploy and aplication on the cluster 
#kubectl cluster-info          //to view the information about the cluster 
#kubectl get nodes             // list all the nodes which are the part of the cluster 

#kubectl run my-web-app --image=my-web-app --replicas=3

#kubectl get namespaces
#kubectl get events -n <namespace>

#kubectl describe pod <pod-name>


Kubernets YAML
=============================================================

each configurartion file has 3 parts 

1) Matadata
2) Specification
---
it depends on the KIND of components (Deployment/Service) that you are creating 
so for deployment it has its own attribute and service has its own attribute 

3) Status
----

first 2 lines of the file will be constent 

    apiVersion: apps/v1
    kind: Deployment/Service