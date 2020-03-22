#!/bin/bash
echo "将yaml文件拷贝到master节点上发布kube-coredns服务"

source ./conf/environment.conf
sed -i "s/10.254.0.2/${CLUSTER_DNS_SVC_IP}/g"  ./yaml/coredns/kube-coredns.yaml
sed -i "s/cluster.local/${CLUSTER_DNS_DOMAIN}/g"  ./yaml/coredns/kube-coredns.yaml
ssh root@${OPS_HOST} "mkdir -p /opt/k8s/yaml/coredns/"
scp -r ./yaml/coredns/kube-coredns.yaml root@${OPS_HOST}:/opt/k8s/yaml/coredns/kube-coredns.yaml
ssh root@${OPS_HOST} "source /etc/profile; kubectl apply -f /opt/k8s/yaml/coredns/kube-coredns.yaml"
echo ">>>>>> kube-coredns服务部署完成 <<<<<<"

