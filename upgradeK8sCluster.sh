#Upgrading K8s with kubeadm

#First, upgrade the control plane node.
#Drain the control plane node.
kubectl drain k8s-control --ignore-daemonsets

#Upgrade kubeadm.
sudo apt update && \
sudo apt install -y --allow-change-held-packages kubeadm=1.21.1-00
kubeadm version

#Plan the upgrade.
sudo kubeadm upgrade plan v1.21.1

#Upgrade the control plane components.
sudo kubeadm upgrade apply v1.21.1

#Upgrade kubelet and kubectl on the control plane node.
sudo apt update && \
sudo apt install -y --allow-change-held-packages kubelet=1.21.1-00 kubectl=1.21.1-00

#Restart kubelet.
sudo systemctl daemon-reload
sudo systemctl restart kubelet

#Uncordon the control plane node.
kubectl uncordon k8s-control

#Verify that the control plane is working.
kubectl get nodes

#Upgrade the worker nodes.
kubectl drain k8s-worker1 --ignore-daemonsets --force

#Log in to the first worker node, then Upgrade kubeadm.
sudo apt update && \
sudo apt install -y --allow-change-held-packages kubeadm=1.21.1-00

#Upgrade the kubelet configuration on the worker node.
sudo kubeadm upgrade node

#Upgrade kubelet and kubectl on the worker node.
sudo apt update && \
sudo apt install -y --allow-change-held-packages kubelet=1.21.1-00 kubectl=1.21.1-00

#Restart kubelet.
sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl uncordon k8s-worker1

#Verify that the cluster is upgraded and working.
kubectl get nodes