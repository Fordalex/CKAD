kubectl config set-context --current --namespace=dev

kubectl create deployment nginx-deploy --image=nginx:stable-alpine --replicas=4 --port=80

kubectl get deploy

kubectl get pods

kubectl describe deploy/nginx-deploy

kubectl get deploy nginx-deploy -o yaml

kubectl expose deployment nginx-deploy --port=9000 --target-port=80 --type=NodePort --name=nginx-svc

kubectl get services

kubectl get services -o yaml

KUBE_EDITOR='nano' kubectl edit deploy/nginx-deploy

curl localhost:[NodePort-Number]

This is helpful if you want to check and change file before applying them to k8s.
--dry-run=client -o yaml > filename.yaml

kubectl create -f ./[folder-name]

kubectl set selector service [service-name] 'key=value'

kubectl scale deploy [deployment-name] --replicates=4

kubectl set image deploy [deployment-name] [image-name]

KUBE_EDITOR='[edtior-name]' kubect edit deploy [deployment-name]


