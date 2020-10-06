=================================================================================
=================================================================================
              ####### GrayLog ########
=================================================================================

Open source log management 
search, analysis, alerting, pipelines, etc 

uses elasticsearch 


Pipeline 
--------
      ------------------------           --------------------           ------------------------                                               
     |        Docker          |         |      FLUENTD       |         |        Kafka           |                                                  
     | ->fluentd log driver<- | ------> |    ->TCP input<-   | ------> |   ->Pub Sub System<-   |              
     |                        |         | ->kafka producer<- |         |                        |                     
      ------------------------           --------------------           ------------------------             
                                                                                   |                                               
                                                                                   |              
      --------------------------           --------------------           ------------------------ 
     |     Elasticsearch        |         |  Graylog Server    |         |       FLUENTD          |
     |->Index, Storage, Query<- | ------> | ->Gelf UDP input<- | ------> |      Containet         |
     |                          |         |    ->REST API<-    |         |   ->Kafka consumer<-   |
      --------------------------           --------------------           ------------------------
                                                     |                
                                                     |              
                      --------------           --------------- 
                     |              |         |    GrayLog    |
                     |     USER     | ------> |   Webserver   |
                     |              |         |               |
                      --------------           ---------------

above pipeline was having many delays and was heavy in the load

solution :-

      -------------------                  -------------------- 
     |       Heka        |                |       Kafka        |
     |->tail log files<- | ----------->   | ->Pub Sub System<- |
     |                   |                |                    |
      -------------------                  -------------------- 
                                                     |
                                                     |   
      --------------------------            ---------------------- 
     |     Elasticsearch        |          |   Graylog Server     |
     |->Index, Storage, Query<- | <------> | ->Gelf kafka input<- |
     |                          |          |    ->REST API & UI<- |
      --------------------------            ---------------------- 

==============================
Graylog Setup through Docker
==============================

#docker run -d --name elasticsearch elasticsearch
#docker run -d --name mongo mongo 
#docker run -p 9000:9000 -d --name graylog --link mongo:mongo --link elasticsearch:elasticsearch -e GRAYLOG_PASSWORD=admin rohit01/graylog
  
  
ADD NODE TO GRAYLOG SERVER To Collect its System Logs

Adding Host to graylogs 
1) create input for port   //http://192.168.44.152:9000/system/input 
2) configure client rsyslog file 
/etc/rsyslogd/*.conf

graylog configration content below 
$template 
  



