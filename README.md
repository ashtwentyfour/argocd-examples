# ArgoCD Examples (Single and Multiple app deployments)

## ArgoCD Setup

- Two GKE clusters were [provisioned](https://cloud.google.com/kubernetes-engine/docs)
- ArgoCD was installed on the first cluster using - 

```
kubectl config use-context gke_pluralsight-gcp-infrastructure_us-central1-c_gke-cluster-1
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- Validated that ArgoCD was installed successfully - 

```
kubectl get pods -n argocd
```

- Exposed the ArgoCD server by running - 

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

- Retrieved the public IP address of the ArgoCD instance -

```
kubectl get svc -n argocd argocd-server
```

- Fetched the ArgoCD 'admin' password - 

```
kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D
```

## Single Helm Chart Sync

- Deployed the application from the ```single-app``` folder to the same cluster that ArgoCD runs on using - 

```
argocd login xx.xx.xx.xx 

argocd app create node-bloom-filter-service --repo https://github.com/ashtwentyfour/argocd-examples.git --path single-app --dest-server https://kubernetes.default.svc --dest-namespace default
```

- Validated that the app was synced -

```
argocd app list

kubectl get pods -n default
```

## Multiple App Deployment ('App of Apps' pattern)

- In this example, two applications were deployed into two different GKE clusters
- The second cluster was added to ArgoCD - 

```
kubectl config use-context gke_pluralsight-gcp-infrastructure_us-east1-b_gke-cluster-2

argocd cluster add gke_pluralsight-gcp-infrastructure_us-east1-b_gke-cluster-2

argocd cluster list
```

- Connected to the first cluster where ArgoCD is running - 

```
kubectl config use-context gke_pluralsight-gcp-infrastructure_us-central1-c_gke-cluster-1
```

- Deployed the Helm chart from the ```multiple-apps``` folder - 

```
cd multiple-apps

helm install multiple-app-stack -n argocd .

argocd app list

argocd proj list

argocd app sync node-bloom-filter-service

argocd app sync node-bloom-filter-service-external

argocd app list
```

- Two applications ```node-bloom-filter-service``` and ```node-bloom-filter-service-external``` were created and deployed into two different clusters
