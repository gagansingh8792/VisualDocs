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

within in the template we have ddefault files been created 

          deployment.yaml       #deployment template
          _helpers.tpl          #helper template
          hpa.yaml
          ingress.yaml
          NOTES.txt             #notes template
          serviceaccount.yaml
          service.yaml
          tests


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

Note:- this will not call the build in object, to call the we have to put "$" in main file where we are call the template as (shown in Demo 2)

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
         {{- template "mychart.systemlabels" $ }}     #putting a "$" at the end that will call the golbal variable from _helper.tpl
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


##### Include template using keyword include

if the intentation is not right in _helper.tpl file we can call the object/variable by "include" keyword

Demo :- 

editing the exernal file _helper.tpl

#vim _helper.tpl  

       {{- define "mychart.systemlabels" }}     #defining the new template
         labels:
           drive:ssd
           machine: frontdrive
           rack: 4c
           vcard: 8g
       {{- end}}
       
       {{- define "mychart.version }}                            #here we have not given proper indentation
       helm: "{{ $.Chart.Name }}-{{ $.Chart.Version }}"            #defining Global Object .Chart.Name and .Chart.Version
       app.kubernetes.io/instance: "{{ $.Release.Name  }}"         #defining Global Object .Release.Name
       app.kubernetes.io/version: "{{ $.Chart.AppVersion  }}"      #defining Global Object .Chart.AppVersion
       app.kubernetes.io/managed-by: "{{ $.Release.Service  }}"    #defining Global Object .Release.Service
       {{- end }}

now we will call the template in main file 

#vim config.yml      

       apiVersion: v1
       kind: ConfigMap
       metadata:
         name: {{.Release.Name}}-configmap
         {{- template "mychart.systemlabels" $ }}     #putting a "$" at the end that will call the golbal variable from _helper.tpl
         {{- include "mychart.version" $ | indent 4 }} #calling version template with "include" keyword, "indent" means indentation.
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

note:- "indent" for labels will be 4 and for data will be 2

##### Include template using keyword include

in Template folder there can we 3 diffrent file 

1) template file which will be the manifest for Kubernetes

2) "NOTES.txt" thats going to have the motes for the file and other helper templates, within the notes.txt we can give the instruction on what all the notes that should get displayed once the chart is deployed and this can act as another template where the normal template syntax can be included within the notes as well, for example, we can access the clobal built in objects as well as the other rules of the template like looking. this can be displayed when running a dey run or any deplyment of helm chart. this note will get diaplyed in the end, that will be useful for the usres to understand.

3) underscore files which is use to define templated and can be called with in the main template file. 

Demo :- 

make new note file in template folder. 

#vim NOTES.txt

       Thank you for suport  {{ .Chart.Name }}.
       
       Your release is named  {{ .Release.Name }}.
       
       to learn more about the release, try:
       
         $ helm status {{ .Release.Name }}
         $ helm get all {{ .Release.Name }}
         $ helm uninstall {{ .Release.Name }}

and now install the helm chart and the note will be displayed at the last when deployment has been completed



##### Sub Charts

subchart will be having a collection of templates and values and the same hierarchy.
Charts is a separate entity where it will be having the collection of templates and values where it can be packaged togeather, shared it with a repository as well as send it as a package to the external chart.
Within "charts" folder we can have n'number of sub charts. 

DEMO :- 

          #cd charts

          #helm create mysubchart   

This will create the subchart inside the parent chart. 
We can define the valed in subchart and call the value form sub template file, if we will define the values in parent value chart it will overwrite the vale of subchart. 


#### Sub Chart global

provide a global value as a part of the parent chart value file 



Demo :- 

edit the parent values.yml

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
                LangUsed:
                  - Python
                  - Ruby
                  - Java
                  - Scala
                mysubchart:
                  dbhostname: prodmysqlnode
                global:                                 #defining golobal value in parent value chart
                  orgdomain: com.muthu4all

edit the parent template file and call the global value defined in parent values chart.

              apiVersion: v1
              kind: ConfigMap
              metadata:
                name: {{.Release.Name}}-configmap
                {{- template "mychart.systemlabels" $ }}     
                {{- include "mychart.version" $ | indent 4 }}
              data:
                myvalue: "sample config Map"
                costCode: {{ .Values.costCode }}
                zone: {{ quote .Values.infra.zone }}
                region: {{ quote .Values.infra.region }}
                projectCode: {{ upper .Values.projectCode }}
                orgdomain: {{ .Values.global.orgdomain }}

edit the sub template file

                apiVersion: v1
                kind: ConfigMap
                metadata:
                  name: {{ .Release.Name }}-innerconfig
                data:
                  dbhost: {{ .Values.dbhostname }}
                  orgdomain: {{ .Values.global.orgdomain }}
                
now run the dry run and see the values called. 

                # helm install --dry-run --debug configmap /tmp/helm-demo/mychart


#### Repository Workflow

Charts Repository and Registry 

the centralized location where all charts are been kept are called as Repository or Registry, Registry is OCI compatable (OCI open container and image standard registry) and thats what its ging to follow within the docker.
we can manage the chart within the registry as well as we can have our own repository as well. 
now a days OCI Registry is supported. 
through which we can manage version and pull whatever version is required and give permision.

#### Repository hosting options

Chart Repository :-

An HTTP server which can host a set of files like index.ymal file an other chart packages.
when the charts are ready, can be uploaded to the server and shared.
Multiple charts with dependency and version can be managed. 
Will be managed like source control system in a common location.
Can be hosed as part of 
  google compute cloud bucket
  AWS s3 bucket
  Github Pages
  Own webserver (chartmuseum) https://chartmuseum.com/docs/#installation

we will be using Chartmuseum for now (https://chartmuseum.com/docs/#installation)

Download the Chart Museum:- 

            curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
          
            chmod +x ./chartmuseum
          
            mv ./chartmuseum /usr/local/bin
          
            chartmuseum --version

Onces done we can start it by local or use GCP or ASW s3 or Github to store the charts  https://chartmuseum.com/docs/#installation

We will start localy : -

            chartmuseum --debug --port=8080 \             #port 8080
            --storage="local" \                           #storage local
            --storage-local-rootdir="./chartstorage"      #dictory where it will store the charts 

Now we can access it through the web browser     http://<ip>:<port>

Add this repo to helm 

     synatx:-      # helm repo add <reponame> <url>
     
     example:-     # helm repo add mychartmuseumrepo http://192.168.253.128:9081
                   
                   # helm repo list
                   # helm search repo nginx          #this will not show any thing cause we have not put any charts in museum


##### Add Chart to Chartmuseum repository

create the chart and to the museum 

1) create the new chart "myrepotest" at client node and edit the "Discription" in "Charts.yaml' within the "myrepotest" chart   

            # helm create myrepotest

            # cd myrepotest
            # vim Charts.yaml 

2) create a package of the chart which will create the "tgz' file "repotest-0.1.0.tgz"

            # helm package repotest/

3) push the chart in master node where chartmuseum is running by using "curl or push" command

            # curl --data-binary "@repotest-0.1.0.tgz" http://192.168.253.128:9081/api/charts

4) Update the helm 

           # helm update

5) check the repo list 
            
           # helm repo list                          #will list all the repo
           # helm search repo <reponame>             #will search the package in repo


#####   Maintain Chart version


Given a version number MAJOR.MINOR.PATCH, increment the:     (https://semver.org/)

MAJOR version when you make incompatible API changes,
MINOR version when you add functionality in a backwards compatible manner, and
PATCH version when you make backwards compatible bug fixes.

We can control the versioning with the Charts.yaml editing "version:" and "appVersion:"





        


         
