kubectl top nodes

If unavailable you'll need to install the add on.

https://github.com/kubernetes-sigs/metrics-server

Prerequisites.

The kube-apiserver must enable an aggregation layer.
Nodes must have Webhook authentication and authorization enabled.
The kubelet certicate needs to be signed by cluster certifcate authorizy; alternatively, you can disable certifcate validation by prssing adding --kubectlet-insecre-tls to the Metrics Server starup command in the manifest.
The container runtime must implement a container metrics RPCs (or have cAdvisor suppport).
The network should support allow the control plane node to reach the matrics server on port 10250.
Metrics server also needs to be able to speak to kubectl on all nodes.

curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/downloads/components.yaml

Update the spec.container.args with --kubelet-insecure-tls

Then apply the components.yaml with kubectl apply -f components.yaml

Check the installation has worked with: kubectl get deployment -n kube-system metrics-server

# Usage

kubectl top pods --all-namespaces
kubectl top pods

while true; do curl http://localhost:30333; sleep 1; done

kubectl get --raw /api/v1/nodes/<something>/proxy/metrics/resource > workernode.txt



kubectl run debug --image=busybox -it --rm -- sh
