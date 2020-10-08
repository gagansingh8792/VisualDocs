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
  
  
                             --------                 --------------------------
                             |      |                | ----------              |
                             | USER |         -------| | Charts |  Repositries |
                             --------         |      | ----------              | 
                                |             |      ---------------------------
                                |             |                   
                                |         --------               ---------------------------
                                |         |      |               | -----------             |
                                 -------->| Helm |-------------->| | Tiller  |    K8s      |
                                          --------               | | Service |  Cluster    |
                                                                 | -----------             |
                                                                 ---------------------------  

In Version V2 Tiller service is the medium between Helm an K8s Cluster.



        V3

                                 --------                --------------------------
                                 |      |                | ---------              |
                                 | USER |         -------| | Charts|  Repositries |
                                 --------         |      | ---------              | 
                                    |             |      --------------------------
                                    |             |                       
                                    |         ---------     --------     --------------
                                    |         |       |     | RBAC |     |            |
                                     -------->| Helm  |----------------->|     K8s    |
                                              ---------                  |   Cluster  |
                                                                         |            |
                                                                         -------------- 


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

1> delete all the files in "templetes folder" and cd templetes
2> create a simple configmap.yml file which will be installed by helm
        
         apiVersion: v1
         kind: Configmap
         metadata:
           name: demo-helm-confgmap
         data:
           myvalue: "simple config Map"

3> install the ConfigMap using Helm     
    
  syntax :- #helm install <name> <Chart_folder_path>

  #helm install helm-demo-configmap /tmp/helm_demo/mychart       ##this will install the ConfigMap 
   
4> list all the installed charts
  #helm ls

5> Kubernetes command to check the deployment
     
  #kubectl get cm -o wide
  #kubectl describe cm <ConfigMap_name>

### Creating Charts in templetes derivative  (VluesFile and Build-In Object)

introdusing the Template Derivative which can be by 2 ways, by Values Files or Build-In Object.

Create 1st chart using Build-In Object : (inatalling simple ConfigMap) 

1> delete all the files in "templetes folder" and cd templetes
2> create a simple configmap.yml file which will be installed by helm
        
         apiVersion: v1
         kind: Configmap
         metadata:
           name: {{.Release.Name}}-confgmap                 # here {{.Release.Name}}  is a template derivative Build In object
         data:
           myvalue: "simple config Map"

3> install the ConfigMap using Helm     
    
  syntax :- #helm install <name> <Chart_folder_path>         # <name> will replace the {{.Release.Name}} 

  #helm install helm-demo-configmap /tmp/helm_demo/mychart       ##this will install the ConfigMap 
   
4> list all the installed charts
  #helm ls

5> Kubernetes command to check the deployment
     
  #kubectl get cm -o wide
  #kubectl describe cm <ConfigMap_name>

6> to check what values were deployed 

  #helm get manifest <chart_name>


Create 1st chart using Value File : (inatalling simple ConfigMap) 

1> delete all the files in "templetes folder" and cd templetes

2> go to the Values.yaml file and edit the value in Key Value format 

syntax:-  key: value

example:-   costCode: CC98112

3> create a simple configmap.yml file which will be installed by helm
        
         apiVersion: v1
         kind: Configmap
         metadata:
           name: {{.Release.Name}}-confgmap                 # here {{.Release.Name}}  is a template derivative Build In object
         data:
           myvalue: "simple config Map"
           costCode: {{ .Value.costCode }}            # this will take thw value from the value.yml file  {{ .Value.<key> }}      

4> install the ConfigMap using Helm     
    
  syntax :- #helm install <name> <Chart_folder_path>         # <name> will replace the {{.Release.Name}} 

  #helm install helm-demo-configmap /tmp/helm_demo/mychart       ##this will install the ConfigMap 
   
5> list all the installed charts

  #helm ls

6> Kubernetes command to check the deployment
     
  #kubectl get cm -o wide
  #kubectl describe cm <ConfigMap_name>

7> to check what values were deployed 

  #helm get manifest <chart_name>

### changing Values from value.yaml file befor release

helm install <chart_name> <chart_path> --set <key>=<value>      #this will chnage the <value> of that we provided of the <key>

helm get manifest <chart_name>



Templates functions -- http://masterminds.github.io/sprig/strings.html


### using multiple Key=Value in a temptale

Entering multipule values in values.yaml file 

[root@kmaster ~]# cat /tmp/helm_demo/mychart/values.yaml

      costCode: CC98112                         #<Key> <Value> 
      projectCode: aazzxxyy                     #<Key> <Value> 
      infra:                                    #<Key> 
        zone: a,b,c                             #<Key> <Value> under the <Key> 
        region: us-e                            #<Key> <Value> under the <Key> 

Calling the Key=Value in ConfigMap.yaml

     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: {{.Release.Name}}-configmap
     data:
       myvalue: "sample config Map"
       costCode: {{ .Values.costCode }}
       zone: {{ quote .Values.infra.zone }}                     #quote is a GO functiwill get the alue inside the quotes ""
       region: {{ quote .Values.infra.region }}                 #quote is a GO functiwill get the alue inside the quotes ""
       projectCode: {{ upper .Values.projectCode }}             #upper is a GO functiwill make the alphabets in uppercase

Dry Run the helm chart

  #helm install --dry-run --debug <chart-name> <chart-path>
  
  #helm install --dry-run --debug multivalueconfig /tmp/helm_demo/mychart

Install helm chart with multivalues 
 
  #helm install  <chart-name> <chart-path>
  
  #helm install multivalueconfig /tmp/helm_demo/mychart

Function :- http://masterminds.github.io/sprig/

### Template pipeline and Default values 

     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: {{.Release.Name}}-configmap
     data:
       myvalue: "sample config Map"
       costCode: {{ .Values.costCode }}
       zone: {{ quote .Values.infra.zone }}                          #quote is a GO function which will get the alue inside the quotes ""
       region: {{ quote .Values.infra.region }}                      #quote is a GO function which will get the alue inside the quotes ""
       projectCode: {{ upper .Values.projectCode }}                  #upper is a GO function which will make the alphabets in uppercase
       pipeline: {{ .Value.projectCode | upper | quote }}            #takes the value of the "projectCode" and make it in upper and quote 
       now: {{ now | date "2006-01-02" | quote }}                    #"now" will take the current date and formats it in date "2006-01-02"
       contact: {{ .Value.contact | default "8960678708" | quote}}   #contact value is not defined in values.yml so it will take the DefaultValue from function 

Dry Run the helm chart  
  
  #helm install --dry-run --debug <chart-name> <chart-path>  
    
  #helm install --dry-run --debug multivalueconfig /tmp/helm_demo/mychart

Install helm chart with multivalues 
 
  #helm install  <chart-name> <chart-path>
  
  #helm install multivalueconfig /tmp/helm_demo/mychart

Function :- http://masterminds.github.io/sprig/


### Flow Control - If/else

syntax:- 
     
      {{ if PIPELINE}}
      #do something
      {{ else if PIPELINE}}
      #do something
      {{ else }}
      #default case 
      {{ end }} 

If condition :-
  
     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: {{.Release.Name}}-configmap
     data:
       myvalue: "sample config Map"
       costCode: {{ .Values.costCode }}
       zone: {{ quote .Values.infra.zone }}                          #quote is a GO function which will get the alue inside the quotes ""
       region: {{ quote .Values.infra.region }}                      #quote is a GO function which will get the alue inside the quotes ""
       projectCode: {{ upper .Values.projectCode }}                  #upper is a GO function which will make the alphabets in uppercase
       {{ if eq .Values.infra.zone "us-e" }}ha: true {{ end }}     

note -> in above "if" condition will check if the .Values.infra.zone is equale to "us-e" if yes then key "ha" value will be "true" and condition ends

note -> the conditon can all be wiriten as below and use - befor the condition this will remove the new line in manifest while installing/deploying

       {{- if eq .Values.infra.zone "us-e" }}
       ha: true 
       {{- end }}


If/else condition :- 

     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: {{.Release.Name}}-configmap
     data:
       myvalue: "sample config Map"
       costCode: {{ .Values.costCode }}
       zone: {{ quote .Values.infra.zone }}
       region: {{ quote .Values.infra.region }}
       projectCode: {{ upper .Values.projectCode }}
       {{- if eq .Values.infra.region "us-w" }}
       ha: region west
       {{- else if eq .Values.infra.region "us-n" }}
       ha: region north
       {{- else }}
       ha: region east
       {{- end }}



#### Template using WITH 

syntax:-

   {{ with PIPELINE }}
   #restricted scope 
   {{ end }}


with condition :- 

editing values in values.yml

    costCode: CC98112
    infra:
      region: us-e
      zone: a,b,c
    projectCode: aazzxxyy
    tags:
      drive: ssd
      machine: frontdrive
      rack: 4c
      vcard: 8g

editing template in config.yml

      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: {{.Release.Name}}-configmap
      data:
        myvalue: "sample config Map"
        costCode: {{ .Values.costCode }}
        zone: {{ quote .Values.infra.zone }}
        region: {{ quote .Values.infra.region }}
        projectCode: {{ upper .Values.projectCode }}
        {{- with .Values.tags }}                                  #With condition
        Machine: {{ .machine | quote }}
        Rack: {{ .rack | quote }}
        Vcard: {{ .vcard | quote }}
        Drive: {{ .drive | upper | quote }}
        {{- end}}


another example of With condition useing in metadata for labels:- 

      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: {{.Release.Name}}-configmap
        labels:
        {{- with .Values.tags }}
          first: {{ .machine }}
          second: {{ .rack }}
          third: {{ .drive }}
        {{- end }}
      data:
        myvalue: "sample config Map"
        costCode: {{ .Values.costCode }}
        zone: {{ quote .Values.infra.zone }}
        region: {{ quote .Values.infra.region }}
        projectCode: {{ upper .Values.projectCode }}
        {{- with .Values.tags }}                                  #With condition
        Machine: {{ .machine | quote }}
        Rack: {{ .rack | quote }}
        Vcard: {{ .vcard | quote }}
        Drive: {{ .drive | upper | quote }}
        {{- end}}


### Looping using RANG :- 

syntax:- 

Lang Used: |-
  {{- range .Values.LangUsed }}
  -{{. | title | quote }}
  {{ end }}

Key and the collection of values

editing values in values.yml

       costCode: CC98112
       infra:
         region: us-e
         zone: a,b,c
       projectCode: aazzxxyy
       tags:
         drive: ssd
         machine: frontdrive
         rack: 4c
         vcard: 8g
       LanUsed:
         - Python
         - Ruby
         - Java
         - Scala

editing template in config.yml


       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         labels:
         {{- with .Values.tags }}
           first: {{ .machine }}
           second: {{ .rack }}
           third: {{ .drive }}
         {{- end }}
       data:
         myvalue: "sample config Map"
         costCode: {{ .Values.costCode }}
         zone: {{ quote .Values.infra.zone }}
         region: {{ quote .Values.infra.region }}
         projectCode: {{ upper .Values.projectCode }}
         Lang Used: |-
           {{- range .Values.LangUsed }}
           - {{. | title | quote }}
           {{- end }}



### Variables :-

with this we can assigne any value to a varable and use it as a value accross the chart

$name.Variable are assigned with a special assignment operator: :=

example: {{- $relname := .Release.Name -}}

editing template in config.yml

       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         labels:
         {{- with .Values.tags }}
           first: {{ .machine }}
           second: {{ .rack }}
           third: {{ .drive }}
         {{- end }}
       data:
         myvalue: "sample config Map"
         costCode: {{ .Values.costCode }}
         zone: {{ quote .Values.infra.zone }}
         region: {{ quote .Values.infra.region }}
         projectCode: {{ upper .Values.projectCode }}
         {{- $relname := .Release.Name}}                      #assiging the value to a varibale 
         LangUsed: |-
           {{- range $index, $topping := .Values.LangUsed }}  #assiging the value to the variable
           - {{ $index }} : {{ $topping | quote }}            # calling variable 
           {{- end }}
         Release: {{ $relname }}                              #calling a variable



Example using Global Objects :- 

         apiVersion: v1
         kind: ConfigMap
         metadata:
           name: {{.Release.Name}}-configmap
           labels:
           {{- with .Values.tags }}
             first: {{ .machine }}
             second: {{ .rack }}
             third: {{ .drive }}
             helm: "{{ $.Chart.Name }}-{{ $.Chart.Version }}"            #calling Global Object .Chart.Name and .Chart.Version
             app.kubernetes.io/instance: "{{ $.Release.Name  }}"         #calling Global Object .Release.Name
             app.kubernetes.io/version: "{{ $.Chart.AppVersion  }}"      #calling Global Object .Chart.AppVersion
             app.kubernetes.io/managed-by: "{{ $.Release.Service  }}"    #calling Global Object .Release.Service
           {{- end }}
         data:
           myvalue: "sample config Map"
           costCode: {{ .Values.costCode }}
           zone: {{ quote .Values.infra.zone }}
           region: {{ quote .Values.infra.region }}
           projectCode: {{ upper .Values.projectCode }}
           {{- $relname := .Release.Name}}
           LangUsed: |-
             {{- range $index, $topping := .Values.LangUsed }}
             - {{ $index }} : {{ $topping | quote }}
             {{- end }}



### Template include another Template :-

we used to keep the temlates as a part of the templates folder and most of the files within the tempalets folder are treated as Kubernetes manifest.
we can also have the other files which is going to start with underscore 
so we can have multiple tempalets in the same file and can be named and can use it elsewhere 

syntex:- 

  {{- define "mychart.labels" }}
    labels:
      generator: helm
      date: {{ now | htmlDate }}
  {{- end }}

 {{- template "mychart.labels" }}

note: defined template can be called again and again.

Demo:- 

editing template in config.yml

       {{- define "mychart.systemlabels" }}     #defining the new template
         labels:
           drive:ssd
           machine: frontdrive
           rack: 4c
           vcard: 8g
       {{- end}}

       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         {{- template "mychart.systemlabels" }}  #calling the template
       data:
         myvalue: "sample config Map"
         costCode: {{ .Values.costCode }}
         zone: {{ quote .Values.infra.zone }}
         region: {{ quote .Values.infra.region }}
         projectCode: {{ upper .Values.projectCode }}
         Lang Used: |-
           {{- range .Values.LangUsed }}
           - {{. | title | quote }}
           {{- end }}   


### Template include - Using Scope

Demo 1 :- 

will create the new file with the underscore under the template forlder. 

#vim _helper.tpl  

       {{- define "mychart.systemlabels" }}         #defining the new template
         labels:
           drive:ssd
           machine: frontdrive
           rack: 4c
           vcard: 8g
       {{- end}}

now we will call the template in main file 

#vim config.yml      

       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         {{- template "mychart.systemlabels" }}       #calling the template
       data:
         myvalue: "sample config Map"
         costCode: {{ .Values.costCode }}
         zone: {{ quote .Values.infra.zone }}
         region: {{ quote .Values.infra.region }}
         projectCode: {{ upper .Values.projectCode }}
         Lang Used: |-
           {{- range .Values.LangUsed }}
           - {{. | title | quote }}
           {{- end }}   

dry run :- 

#helm install --dry-run --debug configmap /tmp/helm-demo/mychart/

Note:- this will not call the build in object, to call the we have to put " . " in main file where we are call the template as (shown in Demo 2)

Demo 2 :-

calling the buildin object from external file
editing the exernal file _helper.tpl

#vim _helper.tpl  

       {{- define "mychart.systemlabels" }}     #defining the new template
         labels:
           drive:ssd
           machine: frontdrive
           rack: 4c
           vcard: 8g
           helm: "{{ $.Chart.Name }}-{{ $.Chart.Version }}"            #defining Global Object .Chart.Name and .Chart.Version
           app.kubernetes.io/instance: "{{ $.Release.Name  }}"         #defining Global Object .Release.Name
           app.kubernetes.io/version: "{{ $.Chart.AppVersion  }}"      #defining Global Object .Chart.AppVersion
           app.kubernetes.io/managed-by: "{{ $.Release.Service  }}"    #defining Global Object .Release.Service
       {{- end}}

now we will call the template in main file 

#vim config.yml      

       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         {{- template "mychart.systemlabels" . }}     #putting a "." at the end that will call the golbal variable from _helper.tpl
       data:
         myvalue: "sample config Map"
         costCode: {{ .Values.costCode }}
         zone: {{ quote .Values.infra.zone }}
         region: {{ quote .Values.infra.region }}
         projectCode: {{ upper .Values.projectCode }}
         Lang Used: |-
           {{- range .Values.LangUsed }}
           - {{. | title | quote }}
           {{- end }}   








