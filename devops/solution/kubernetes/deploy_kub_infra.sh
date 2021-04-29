gcloud container clusters list
gcloud container clusters get-credentials <CHANGE_ME_TO_PROJECT_ID>-gke --zone=europe-west2-c

bash ./labelnodes.sh
kubectl apply -f techtest-ns.yaml
kubectl apply -f techtest-ingress.yaml
kubectl apply -f techtest-service.yaml
kubectl apply -f techtest-appdeployment.yaml
