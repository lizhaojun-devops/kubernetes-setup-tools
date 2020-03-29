#!/bin/bash
clear
echo -e "\033[36m开始下载k8s组件的安装包...\033[0m"
yum install wget ftp sshpass openssh -y >/dev/null 2>&1
mkdir ./work
rm -rf ./work/*
cd ./work
source ../conf/environment.conf
echo " "
echo "下载kubernetes-server kubernetes-client包"
wget -c https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/kubernetes-server-linux-amd64.tar.gz
wget -c https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/kubernetes-client-linux-amd64.tar.gz
echo "下载etcd安装包"
wget -c https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
echo "下载flannel"
wget -c https://github.com/coreos/flannel/releases/download/${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz
echo "下载cfssl"
wget -c https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O cfssl
wget -c https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O cfssljson
wget -c https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 -O cfssl-certinfo
echo "下载nginx"
wget -c http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
echo "下载centos kernel"
wget -c http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/kernel-ml{,-devel}-${Kernel_Version}.el7.elrepo.x86_64.rpm
echo ""
echo "download ok！"
echo ""
cd ..

