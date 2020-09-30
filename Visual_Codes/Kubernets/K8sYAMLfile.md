
=================================================================================
=================================================================================
              #######  POD yaml ########
=================================================================================

POD YAML

# Running single POD container:-

apiVersion: v1
kind: Pod

metadata:
  name: nginxpod
  labels:
    env: prod

spec:
  containers:
    - name: containername
      image: nginx 

========================================================

# Defining enviornment in container

apiVersion: v1
kind: Pod

metadata:                  #defining data of POD
  name: nginxpod           #name of POD
  labels:                  #defining labels (if required)
    env: prod

spec:                       #defining specifications of POD
  containers:
    - name: containername        #container name 
      image: nginx               #image name 
      env:                       #environment
        - name: myname           #environment key 
          value: Gagan           #environment value 
        - name: city
          value: lucknow 
      args: [ "sleep", "50" ]    #command inside the container

========================================================

# Multiple Contaiers    (note: multipul container in single pod use the shared network and port)

apiVersion: v1
kind: Pod

metadata:                                  #defining data of POD
  name: nginxpod                           #name of POD
  labels:                                  #defining labels (if required)
    env: prod

spec:                                      #defining specifications of POD
  containers:
    - name: first                          #first container name 
      image: nginx                         #image name 
      env:                                 #environment
        - name: myname                     #environment key 
          value: Gagan                     #environment value 
        - name: city
          value: lucknow 
      args: [ "sleep", "3600" ]            #command inside the container 
    - name: second                         #second container name 
      image: coolgourav147/nginx-custom    #image name 

============================================================

# Createing initContainer  

(initContainer gets executed first and then normal containers get starts)
(use-case: can use to check the database status before running up the aplication)

apiVersion: v1
kind: Pod

metadata:                                  #defining data of POD
  name: nginxpod                           #name of POD
  labels:                                  #defining labels (if required)
    env: prod

spec:                                      #defining specifications of POD
  containers:
    - name: first                          #first container name 
      image: nginx                         #image name 
      env:                                 #environment
        - name: myname                     #environment key 
          value: Gagan                     #environment value 
        - name: city
          value: lucknow 
      args: [ "sleep", "3600" ]            #command inside the container 
    - name: second                         #second container name 
      image: coolgourav147/nginx-custom    #image name 
  initContainers:                          # initContainer
    - name: initcontainer1                 #initContainer name 
      image: coolgourav147/nginx-custom    #image name 
      env:                                 #environment
        - name: myname                     #environment key 
          value: Gagan                     #environment value 
        - name: city
          value: lucknow 
      args: [ "sleep", "30" ]            #command inside the initContainer 

(note: can also define the multiple initContainer)

### POD stuck in Terminating stage.

Some times Pod get stuck in Terminating state then we have to forcefully delete the POD with grace-period=0

command :-    # kubectl delete pod --grace-period=0 --force --namespace <NAMESPACE> <PODNAME>

We can also use the FOR LOOP with kubectl command :- 

   #for p in $(kubectl get pod --namespace <NAMESPACE> | grep Terminating | awk '{print $1}'); do kubectl delete pod $p --grace-period=0 --force;done

(for exmaple) : -
#kubectl get pod -n <NAMESPACE>
NAME        READY     STATUS        RESTARTS   AGE
pod-186o2   1/1       Terminating   0          2h
pod-4b6qc   1/1       Terminating   0          2h
#kubectl delete pod --grace-period=0 --force --namespace <NAMESPACE> <PODNAME>


=================================================================================
=================================================================================
              #######  Services yaml ########
=================================================================================

here we have covered 2 types of service "ClusterIP" and "NodePort"

### ClusterIP service type  (which can be accessed inside the Cluster)

ClusterIP only allows to access the application throught IP within the cluster only.

#kubectl expose pod nginxpod --port=8000 --target-port=80 --name=myclusterip

in above command  "--port"  is the cluster port and "--target-port"  request redirect port 
means when ever request comes to port "8000" with redirect to port "80"

### NodePort service type  (can be accessed outside the cluster) 

NodePort allows to access the application outside the cluster like browser.

#kubectl expose pod nginxpod --type=NodePort --port=8000 --target-port=80 --name=myservice1

in above command "--type" is use to define the type of service, it will create the new port that is accessble through browser
"--port"  is the cluster port and "--target-port"  request redirect port 
means when ever request comes to port "8000" with redirect to port "80"

### NodePort YAML

apiVersion: v1

kind: Service

matadata:
  name: myservice1
  labels:
    servicelbl: nginxservice

spec:
  type: NodePort
  ports:
    - NodePort: 32000
      port: 9000
      targetPort: 80
  selector:
    type: app    


=================================================================================
=================================================================================
              #######  ReplicationController yaml ########
=================================================================================

sences the replicas of the POD

ReplicationSet use Eqality Base Selector 

#### ReplicationController YAML

apiVersion: v1

kind: ReplicationController

metadata:
  name: firstrcaset
  labels:
    app: votingapp

spec:
  replicas: 5
  template:
    metadata:
      name: nginxpod
      labels:
        env: prod
        type: app
    spec:
      containers:
        - name: containername
          image: coolgourav147/nginx-custom


#### Replication Controller using Selector in yml

apiVersion: v1

kind: ReplicationController

metadata:
  name: firstrcaset
  labels:
    app: votingapp

spec:
  replicas: 5
  selector:
    type: app
  template:
    metadata:
      name: nginxpod
      labels:
        env: prod
        type: app
    spec:
      containers:
        - name: containername
          image: coolgourav147/nginx-custom




#### Replication Controller Scaling

K8 supports 3 types of input .. 
1) Imperative command 
2) Imperative object configuration
3) Declarative object configuration

kubectl scale rc --replicas=7 <ReplicationController_Name>       //Imperative command CLI

kubectl edit rc <ReplicationController_Name>    //Imperative object configuration

kubectl replace rc <ReplicationController_Name>  //Imperative object configuration
//edit the yml file and hit the replace rc command// 

kubectl apply -f rc <ReplicationController_Name>   //Declarative object configuration


=================================================================================
=================================================================================
              #######  ReplicationSet yaml ########
=================================================================================

ReplicationSet is a modified version of ReplicationController 

ReplicationSet use Set Base Selector 

#### ReplicationController YAML

apiVersion: apps/v1

kind: ReplicaSet

metadata:
  name: rs1
  labels:
    name: rc1

spec:                                 #replicationset specification
  replicas: 7                         #numer of replicas
  selectrol:                          #defining set base selector
    matchExpressions:                 #defining selector expresions
      - key: type                     #defining key (labels key)
        operator: In                  #defining opration which can be "In" or "NotIn" 
        values:                       #defining values (labels values of key)
          - backend
          - frontend
      - key: env
        operator: NotIn
        values:
          - nonprod
  templete:                           # templete where we will define PODs metadata and spec
    metadata:
      name: pod1
      labels:
        env: prod
        type: frontend
    spec:                             #POD specification
      containers:
        - name: containername
          image: coolgourav147/nginx-custom
          env:
            - name: myname
              value: Gagan
            - name: City
              value: Luncknow


=================================================================================
=================================================================================
              #######  DEPLOYMENT ########
=================================================================================

onces you deploy you application it will create the following flow :

              -------------------------------                                           
              |          Deployment         |                                        
              |  -------------------------  |                                   
              |  |     ReplicationSet    |  |                               
              |  |  -------------------- |  |                               
              |  |  |                  | |  |             -------------------
              |  |  |      POD1        | |  |             |                 |
              |  |  |      POD2        | |  |  -----------|    Service      |                
              |  |  |      POD3        | |  |             |                 | 
              |  |  |      POD4        | |  |             ------------------- 
              |  |  |      POD5        | |  |                               
              |  |  |                  | |  |                                                  
              |  |  |                  | |  |                               
              |  |  -------------------- |  |                           
              |  -------------------------  |
              -------------------------------

### Deployment Strategy
 
1) Recreate Deployment  
      
All existing Pods are killed before new ones are created 

*If we upgrade a Deployment, all Pods of the old revision will be terminated immediately. 
*After the successful removal new POD are created with the new version.
*If we manually delete a Pod, the lifecycle is controlled by the ReplicaSet and the replacement will be created immediately (even if the old Pod is still in a Terminating state). If we need an "at most" guarantee for your Pods, ywe should consider using a StatefulSet.

2) Rolling Update Deployment

its an default Strategy in K8s
The Deployment updates Pods in a rolling update fashion


### Deployment YAML


apiVersion: apps/v1

kind: Deployment

metadata:
  name: deploy1
  labels:
    name: deploy1

spec:
  replicas: 5
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      name: dpod
      labels:
        app: myapp
    spec:
      containers:
        - name: container
          image: coolgourav147/nginx-custom:v1


to check the rollout status (rollout trigers when you change in POD template and apply deployment)
#kubectl rollout status deploy <deploymen_name>


### Deployment YAML (RollingUpdate)


apiVersion: apps/v1

kind: Deployment

metadata:
  name: deploy1
  labels:
    name: deploy1

spec:
  replicas: 10
  minReadySeconds: 30
  selector:
    matchLabels:
      app: myapp
  strategy:
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      name: dpod
      labels:
        app: myapp
    spec:
      containers:
        - name: container
          image: coolgourav147/nginx-custom:v1

    
Note :-  maxSurge: 2    (total number of pod will be 12 (10-replica + 2-Surge)while rollingUpdate the new image, if 4 new pod gets created then only 2 will be deleted and 8 will be there in old means total 12)


### Default Rollout

If we dont define "strategy: minReadySeconds: maxSurge: maxUnavailable:" stage in deployment.yaml the Default "strategy" will be "rollingUpdate", "minReadyState" will be 0, "maxSurge" will be 25% and "maxUnavailable" will be 25%

 Valid resource types include:

  *deployments
  *daemonsets
  *statefulsets

Examples:
  #Rollback to the previous deployment
  kubectl rollout undo deployment/abc

  #Check the rollout status of a daemonset
  kubectl rollout status daemonset/foo

Available Commands:
  history     View rollout history                     #kubectl rollout history deployment <DeploymentName>
  pause       Mark the provided resource as paused     #kubectl rollout pause deployment <DeploymentName>  
  restart     Restart a resource                       #kubectl rollout restart deployment <DeploymentName>
  resume      Resume a paused resource                 #kubectl rollout resume deployment <DeploymentName>
  status      Show the status of the rollout           #kubectl rollout status deployment <DeploymentName>
  undo        Undo a previous rollout                  #kubectl rollout undo deployment <DeploymentName>


to see the history   #kubectl rollout history deployment <DeploymentName>

to add record : #kubectl rollout history deployment <DeploymentName> --record

to add coustome record we need to add the "annotation:" under deployment "metadata:"

metadata:
  name: deploy1
  labels:
    name: deploy1
  annotations:
    kubernetes.io/change-cause: "custom message"


Roll back to old revision 

#kubectl get rs                    //this will show all the revisions.
#kubectl rollout undo deployment <DeploymentName>  // this will deploy the just old revision which was runinig before the new one.
#kubectl rollout undo --to-revision=<RivisionNumber> deployment <DeploymentName>  // this will deploy the user difined revision number. 


=================================================================================
=================================================================================
              #######  Resource Request ########
=================================================================================


Defining the minimum and maximum resource requirement and usage of the POD that might be RAM CPU 

resouce is always defined at POD level

resources:
  requests:                //defining the Minimum resource required to start a container 
    memory: 200MiB         //MiB is Mebibyte
    cpu: 100m              //CPU will alwasy be define im Milli CPU means 1-CPU contains 1000-MilliCPU   
  limits:                  //defining Maximum resource that container can use 
    memory: 300MiB


NOTE: here MiB is Mebibyte is a power of 2 (in multiples of 10) 
Eg. 1 MiB = 2^20 bytes = 1048576 bytes 
or we can say, 1 MiB = 1024 KiB
{ 1 KiB (Kibibyte) = 2^10 bytes = 1024 bytes }


=================================================================================
=================================================================================
              #######  NAMESPACE ########
=================================================================================

Multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces

Que) what are the default Namespaces in kubernetes 
Ans) The first three namespaces created in a cluster are always "default", "kube-system", and "kube-public"
   1) "Default" -- is for deployments that are not given a namespace.
   2) "Kube-system" -- is for all things relating to Kubernetes system.
   3) "Kube-public" -- is readable by everyone, but the namespace is reserved for system usage.

Que) which resources support namespace?
Ans) throught "kubectl api-resources" we could see which resources support namespace
     "kubectl api-resources | grep -i true"

Que) How to change the "default" namespace by other namespace in kubernetes configuration?
Ans) kubectl config set-context --current --namespace=<New_Namespace>


apiVersion: v1
kind: Namespace
metadata:
  name: myns


=================================================================================
=================================================================================
              #######  Service DNS ########
================================================================================= 


making communication between 2 namespaces 


<service-name>.<service-namespace>.svc.cluster.local


=================================================================================
=================================================================================
              ####### ResourceQuota ########
================================================================================= 

Compute Quota(cpu and mem) and Object Quota(pods)

ResourceQuota sets aggregate quota restrictions enforced per namespace

kubectl explain quota

apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota-demo
  namespace: <namespace>
spec:
  hard:
    pods: 2
    requests.cpu: 0.5
    requests.memory: 100Mi
    limits.cpu: 1
    limits.memory: 800Mi



https://kubernetes.io/docs/concepts/policy/resource-quotas/

to see ResourceQuota applied on a namespace 
#kubectl get quota -n <namespace>

to see detailed ResourceQuota on a namespace 
#kubectl describe <quota_name> -n <namespace> 


=================================================================================
=================================================================================
              ####### LimitRange ########
================================================================================= 

kubectl explain limits 


apiVersion: v1
kind: LimitRange
metadata:
  name: limit
  namespace: <namespace>
spec:
  limits:
    - default:
        cpu: 200m
        memory: 600Mi
      defaultRequest:
        cpu: 100m
        memory: 150Mi
      max:
        cpu: 700m
        memory: 700Mi
      min:
        cpu: 80m
        memory: 100Mi
      type: Container

Note:- the "max:" should alway be greated then Default


#### LimitRatio

piVersion: v1
kind: LimitRange
metadata:
  name: limit
  namespace: <namespace>
spec:
  limits:
    - maxLimitRequestRatio:
        memory: 2                        // 2 is the (Max Limit/Request Ratio) defined by user
      type: Container

note : Max Limit/Request should be 2 or less 


Limits can be applied to multiple resources apart from Container
1. Container
2. Pod
3. Image
4. ImageStream
5. PersistentVolumeClaim (pvc)


=================================================================================
=================================================================================
              ####### Config Map ########
================================================================================= 

ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

to see existing configmaps
kubectl get cm 

to create new config map

#kubectl create cm <configmap_name> --from-literal=<Key=Value>         //we can directly define the kye value
example: #kubectl create cm <configmap_name> --from-literal=database_ip="192.168.0.4"

#kubectl create cm <configmap_name> --from-file=<file_Path>   // we have define kye vale inside the file <key=value>

Options:

--allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.

--append-hash=false: Append a hash of the configmap to its name.

--from-env-file='': Specify the path to a file to read lines of key=val pairs to create a
configmap (i.e. a Docker .env file).

--from-file=[]: Key file can be specified using its file path, in which case file basename
will be used as configmap key, or optionally with a key and file path, in which case the given key
will be used.  Specifying a directory will iterate each named file in the directory whose basename
is a valid configmap key.

--from-literal=[]: Specify a key and literal value to insert in configmap (i.e.
mykey=somevalue)

--save-config=false: If true, the configuration of current object will be saved in its
annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to
perform kubectl apply on this object in the future.

--template='': Template string or path to template file to use when -o=go-template,



now in a live project we have n'numbers of property file so we can create 1 folder containeing all the properties file and create a ConfigMap

 kubectl create cm cm3 --from-file=<folder_path>

### Config Map YMAL

apiVersion: v1
kind: ConfigMap
data:
  key1: value1 
  key2: value2
  key3: value3
  key4: value4
  key5: value5
metadata:
  name: cm2
  namespace: <namespace>


/// defining multiple properties /// 

apiVersion: v1
data:
  application.properties: |
    appkey1=value1
    appkey2=value2
    appkey3=value3
  superadmin.properties: |
    super1=value1
    spare2=value2
    supar3=value3
    supare4=value4
  test.properties: |
    test1=value1
    test2=value2
    test3=value3
    test4=value4
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: cm3

### Inject ConfigMap in Pods

we can inject configmap in pad and get them in 2 forms as a "environment variable" and " file "

1) Environment Valiable (defining Variables as env: in pod)

apiVersion: v1
kind: Pod
metadata:
  name: testpod1
  labels:
    env: prod
spec:
  containers:
    - name: testpod1
      image: coolgourav147/nginx-custom:v1
      imagePullPolicy: Never
      env:                                           #defining env
        - name: <EnvVariable_Name>                   #name of env variable (eg: PSQL_PASSWORD) 
          valueFrom:
            configMapKeyRef:
              key: <ConfigMap_Value>                 #key inside the configmap
              name: <ConfigMap_Name>                 #name of config_file (to get the name :- kubectl get cm <ConfigMap_Name> -n <namespace>)
        - name: <EnvVariable_Name>                   #name of env variable (eg: PSQL_PASSWORD) 
          valueFrom:
            configMapKeyRef:
              key: <ConfigMap_Value>                 #key inside the configmap
              name: <ConfigMap_Name>                 #name of config_file (to get the name :- kubectl get cm <ConfigMap_Name> -n <namespace>)

2) Environment file (defining file as env: in pod)


apiVersion: v1
kind: Pod
metadata:
  name: testpod2
  labels:
    env: prod
spec:
  containers:
    - name: testpod2
      image: coolgourav147/nginx-custom:v1
      imagePullPolicy: Never
      envFrom:
        - configMapRef:
            name: <comfigmap_name>                          #configmap name 



=================================================================================
=================================================================================
              ###### Secrets ########
================================================================================= 

Kubernetes Secrets let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Storing confidential information in a Secret is safer and more flexible than putting it verbatim in a Pod definition or in a container image.


Available Commands:
  docker-registry Create a secret for use with a Docker registry
  generic         Create a secret from a local file, directory or literal value    //commenly used 
  tls             Create a TLS secret

Usage:
  kubectl create secret [flags] [options]


generic :- 

Examples:

  // ##Create a new secret named my-secret with keys for each file in folder bar

  kubectl create secret generic my-secret --from-file=path/to/bar

  // ##Create a new secret named my-secret with specified keys instead of names on disk

  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa --from-file=ssh-publickey=path/to/id_rsa.pub

  // ##Create a new secret named my-secret with key1=supersecret and key2=topsecret

  kubectl create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret

  // ##Create a new secret named my-secret using a combination of a file and a literal

  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa --from-literal=passphrase=topsecret

  // ##Create a new secret named my-secret from an env file

  kubectl create secret generic my-secret --from-env-file=path/to/bar.env

