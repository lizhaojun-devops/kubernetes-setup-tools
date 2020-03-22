#!/bin/bash
clear
echo -e "\033[36m开始下载k8s组件的安装包...\033[0m"
sh -c "$(curl -fsSL http://172.19.30.116/mirror/.help/centos_install.sh)"
sh -c "$(curl -fsSL http://172.19.30.116/mirror/.help/epel_install.sh)"
yum install wget ftp sshpass openssh -y >/dev/null 2>&1
mkdir ./work
rm -rf ./work/*
cd ./work
source ../conf/environment.conf
echo " "
echo "下载kubernetes-server kubernetes-client包"
wget -c ftp://172.19.2.252/Kubernetes/kubernetes-binary-amd64/${KUBE_VERSION}/kubernetes-server-linux-amd64.tar.gz
wget -c ftp://172.19.2.252/Kubernetes/kubernetes-binary-amd64/${KUBE_VERSION}/kubernetes-client-linux-amd64.tar.gz
echo "下载etcd安装包"
wget -c ftp://172.19.2.252/Kubernetes/etcd/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
echo "下载flannel"
wget -c ftp://172.19.2.252/Kubernetes/flannel/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz
echo "下载cfssl"
wget -c ftp://172.19.2.252/Kubernetes/cfssl/cfssl-certinfo_linux-amd64 -O cfssl-certinfo
wget -c ftp://172.19.2.252/Kubernetes/cfssl/cfssl_linux-amd64 -O cfssl
wget -c ftp://172.19.2.252/Kubernetes/cfssl/cfssljson_linux-amd64 -O cfssljson
echo "下载nginx"
wget -c ftp://172.19.2.252/Kubernetes/nginx/nginx-${NGINX_VERSION}.tar.gz
echo "下载centos kernel"
wget -c ftp://172.19.2.252/Kubernetes/kernel/kernel-ml-${Kernel_Version}.el7.elrepo.x86_64.rpm
wget -c ftp://172.19.2.252/Kubernetes/kernel/kernel-ml-devel-${Kernel_Version}.el7.elrepo.x86_64.rpm
echo ""
echo "download ok！"
echo ""
cd ..

