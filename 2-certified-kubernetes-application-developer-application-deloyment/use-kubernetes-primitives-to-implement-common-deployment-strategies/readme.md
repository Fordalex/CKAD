using kubectl to generate templates for deployments.
 
declaratively is creating a file and typing by hand.

But we can do this imperatively can generate the file using kubectl.

kubectl create deployment nginx --image=nginx:alpine --dry-run=client -o yaml > deploy.yaml
kubectl create -f deployment.yaml
kubectl scale deployment nginx --replicas=4 (remember this is all imperatively, you might be asked to this do this the exam)

services/deployments this will speedup the time in the exam.

--- Blue/Green deployments (sounds like we already do this with StaffSafe)

test-service, public-service and a deployment.


