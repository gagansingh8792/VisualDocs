Ingress
=========
Ingress is an API object that provides routing rules to manage external users' access to the services in a Kubernetes cluster, typically via HTTPS/HTTP
With Ingress, we can easily set up rules for routing traffic without creating a bunch of Load Balancers or exposing each service on the node. 
Ingress Controller is the actual implementation of the Ingress API. 
The Ingress Controller is usually a load balancer for routing external traffic to your Kubernetes cluster and is responsible for L4-L7 Network Services. 

Layer 4 (L4) refers to the connection level of the OSI network stack—external connections load-balanced in a round-robin manner across pods. 
Layer 7 (L7) refers to the application level of the OSI stack—external connections load-balanced across pods, based on requests. 
Layer 7 is often preferred, but you should select an Ingress Controller that meets your load balancing and routing requirements.