
Kubectl Commands
================

kubectl version                 // Kubernetes Version Information (Clinet version and Server Version)
kubectl version --short 

kubectl get componentstatus     // Components Helath Status

kubectl cluster-info            // Cluster information 

kubectl get nodes               // Nodes information 

kubectl get nodes -o wide       // node info with "IP, OS, KernalVersion, DockerVersion"

kubectl get namespace           // Name space information



kubectl get secret,sa,role,rolebinding,services,deployments --namespace=kube-system | grep dashboard

kubectl delete deployment kubernetes-dashboard --namespace=kube-system 
kubectl delete service kubernetes-dashboard  --namespace=kube-system 
kubectl delete role kubernetes-dashboard-minimal --namespace=kube-system 
kubectl delete rolebinding kubernetes-dashboard-minimal --namespace=kube-system
kubectl delete sa kubernetes-dashboard --namespace=kube-system 
kubectl delete secret kubernetes-dashboard-certs --namespace=kube-system
kubectl delete secret kubernetes-dashboard-key-holder --namespace=kube-system

--------------------------

Degubing command 
----------------

jump in the pod bash :-

kubectl exec <pod_name> -it bash  // jum into the conatiers bash shell

see environment in the pod :-

kubectl exec <pod_name> env     //single pod 
kubectl exec <pod_name> -c <contntainer_name> env   //for the specific container in the pod



