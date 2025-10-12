# Task

1. Create a Deployment named **nginx-deploy**. The Deployment should use the **nginx:stable-alpine** image and create **4** replicas.

2. Create a **NodePort** service named **nginx-svc** and associate it with the Pods created by the **nginx-deploy** Deployment. The service should expose port **9000**.

3. Edit the **nginx-deploy** Deployment and change the number of replicas to **6**.

4. Ensure the service is associated with the **nginx-deploy** Pods by running the following command and checking that it returns HTML content. Replace **<node-port>** with the **nginx-svc** node port value.

# Answer

kubectl config set-context --current --namespace=dev

kubectl create deployment nginx-deploy --image=nginx:stable-alpine --replicas=4 --port=80

kubect get deploy

kubectl get pods

kubectl describe deploy/nginx-deploy

kubectl get deploy nginx-deploy -o yaml

kubectl expose deployment nginx-deploy --port=9000 --target-port=80 --type=NodePort --name=nginx-svc

kubectl get services

kubectl get services -o yaml

KUBE_EDITOR='nano' kubectl edit deploy/nginx-deploy

curl localhost:<NodePort-Number>
