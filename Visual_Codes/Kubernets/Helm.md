=================================================================================
=================================================================================
              #######  HELM ########
=================================================================================

Helm is a package manager for Kubernetes. Helm is the K8s equivalent of yum or apt. 
Helm deploys charts, which we can think of as a packaged application.

its going to Visualize the application as a package where all the dependencies will be packed togeather and etire package can be shared as well as deployed into a kuberbetes Cluster.
Also, it facilitates to upgrade and roll back the changes by maintaining the versions.

### Need of Helm 

within the cluster will be deploying n'number of entities like Pods, Services, deployment, Secrets, Config files 

### Components of Helm

Helm Client: 
inetface by which helm can be communicated, It facilitate the intreaction between user and helm components as well kubernetes cluster

Charts:
Building block of helm where the entire aplication defination will be within the chart and chart provides the various fetures how the application can be defined with in the Kubernetes environment.
it has the collection of Files and diffrent structures to define values and how to build a sub charts.

Repositries:
trorage environment where various charts of variout applications can be stored and shared within the team or across the team.

Release:
once the chart is been release to the environment, that instance we call it as release and also we can have multiple version of release in multiple enviornment, that all will be managed by Helm Client.
Instance of a chart that is deployed into the environment. 

### Difference Between V2 and V3 


         V2
   ______                  ________________________
  |      |                |  _______               |
  | USER |         -------| | Charts|  Repositries |
  |______|         |      | |_______|              | 
     |             |      |________________________|
     |             |                   _________________________
     |          ___|___               |  _________              |
     |         |      |               | |         |             |
     |-------->| Helm |-------------->| | Tiller  |    K8s      |
               |______|               | | Service |  Cluster    |
                                      | |_________|             |
                                      |_________________________|  

In Version V2 Tiller service is the medium between Helm an K8s Cluster.



        V3

   ______                  ________________________
  |      |                |  _______               |
  | USER |         -------| | Charts|  Repositries |
  |______|         |      | |_______|              | 
     |             |      |________________________|
     |             |                       ____________
     |          ___|___       ______      |            |
     |         |       |     | RBAC |     |            |
     |-------->| Helm  |----------------->|     K8s    |
               |_______|                  |   Cluster  |
                                          |            |
                                          |____________|  


In version V3 Tiller service is been removed and RBAC (Roll Based Access Control) is introduced which be communicater between Helm and K8s Cluster.


### Helm Installation

    https://helm.sh/docs/intro/install/#helm
    https://github.com/helm/helm/releases/tag/v3.3.4


### Helm Configuration Paths 

| Operating System | Cache Path                | Configuration Path             | Data Path               |
|------------------|---------------------------|--------------------------------|-------------------------|
| Linux            | $HOME/.cache/helm         | $HOME/.config/helm             | $HOME/.local/share/helm |


Path were all the repositiers will be stored :- /root/.cache/helm/repository  


### Helm Hub (public reositry)

    https://hub.helm.sh/

    CLI :- 
          helm search repo        #listting all the charts in helm hum 
          helm repo add stable https://kubernetes-charts.storage.googleapis.com/         #adding stable repo
          helm repo list         #listting all the repos 

### Install charts

  #helm ls           # list all the charts that has been deployed               

  #helm search repo <repo_name>
  #helm install <repo_name> --generate-name     # --generate-name will automaticly generats the name for mysql
  #helm install <chart_name> <repo_name>              # <chart_name> is user generated name

Inatslling msql :- 

  #helm search repo stable/mysql                  # search the chart for msql
  #helm install stable/mysql --generate-name      # install the mysql and --generate-name will automaticly generats the name for mysql

Installing AirFlow:-

  #helm search repo stable/airflow              # search the chart for airflow
  #helm install myairflow stable/airflow        # inatsll the airflow and myairflow is user generated name

To see all the resources created on Kubernetes 

  #kubectl get all -n <namespace> -o wide

### Uninstall the charts 

List all the charts that has been deployed 

  #helm ls      # list all the installed charts  

Uninstall Chart

  #helm uninstall <chart_name>   # uninstall all resousres created on kubernetes


### Creating Charts

Create Chart

  #helm create <chart_name>      # create chart

  by default it will create files and folder 'charts' 'Chart.yaml' 'templates' and 'values.yaml' within newely created Chart

  charts : where allthe components will be stored 
  templetes: where all the yaml will be created

### Creating Charts in templetes

  Create 1st chart (inatalling simple ConfigMap):

   1) delete all the files in "templetes folder" and cd templetes
   2) create a simple configmap.yml file which will be installed by helm
        
         apiVersion: v1
         kind: Configmap
         metadata:
           name: demo-helm-confgmap
         data:
           myvalue: "simple config Map"
   
   3) install the ConfigMap using Helm     syntax :- #helm install <name> <Chart_folder_path>

      #helm install helm-demo-configmap /tmp/helm_demo/mychart    //this will install the ConfigMap 