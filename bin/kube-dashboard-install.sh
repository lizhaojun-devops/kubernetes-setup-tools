#!/bin/bash
echo "开始部署kube-dashboard"
echo "将yaml文件拷贝到master节点上发布dashboard服务"
source ./conf/environment.conf
ssh root@${OPS_HOST} "mkdir -p /opt/k8s/yaml/dashboard/"
scp -r ./yaml/dashboard/kube-dashboard.yaml root@${OPS_HOST}:/opt/k8s/yaml/dashboard/kube-dashboard.yaml
ssh root@${OPS_HOST} "source /etc/profile; kubectl apply -f /opt/k8s/yaml/dashboard/kube-dashboard.yaml"
sleep 10s
echo "正在对用户进行授权"
source ./conf/environment.conf
ssh root@${OPS_HOST} "source /etc/profile; kubectl create clusterrolebinding login-dashboard-kubeadmin --clusterrole=cluster-admin --user=kubeadmin"


echo ">>>>>> Kubernetes Dashboard 部署完成 <<<<<<"

