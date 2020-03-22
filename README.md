# kubernetes自动部署工具(内网版本)

## 如何使用
* 找个虚拟机,能够远程ssh你的k8s节点地址的作为部署机器,远程进行部署


### 方式一

从git服务器获取最新的部署脚本

```
git clone http://git.tophc.top/kubernetes/kunernetes-setup-tools.git 
cd kunernetes-setup-tools
git checkout intranet        #切换到内网版本分支
vim conf/environment.conf    #修改自己的环境信息
```


### 方式二

从FTP服务器获取安装脚本, CICD平台会自动上传部署脚本到FTP服务器

```
wget ftp://172.19.2.252/Kubernetes/自动部署工具/kubernetes-setup-tools-intranet.tar.gz
tar -zxf kubernetes-setup-tools-intranet.tar.gz
cd kubernetes-setup-tools-intranet
vim conf/environment.conf    #修改自己的环境信息
```

## 节点规划

* 修改 `conf`下的`environment.conf`; 里面指定节点的信息,如下为举例说明

总共有5个节点,三个master高可用,master也参与到node的工作中,这样就有了5个可用的节点

| IP | role | other |
| :-: | :-: | :-: |
| 10.100.4.20 | VIP | keepalive VIP (面向apiserver的负载) |
| 10.100.4.21 | master+node | etcd,kube-apiserver,kube-schedule,kube-controller-manager,kube-kubelet,kube-proxy |
| 10.100.4.22 | master+node | etcd,kube-apiserver,kube-schedule,kube-controller-manager,kube-kubelet,kube-proxy |
| 10.100.4.23 | master+node | etcd,kube-apiserver,kube-schedule,kube-controller-manager,kube-kubelet,kube-proxy |
| 10.100.4.24 | node | kube-kubelet,kube-proxy |
| 10.100.4.25 | node | kube-kubelet,kube-proxy |


* **安装过程会从`172.19.2.252`的FTP上下载文件,请保持所有节点和`172.19.2.252`能够正常通信**
* 三个master高可用,部署keepalive产生VIP用做kube-apiserver的地址, 三台master部署nginx做kube-apiserver的tcp负载均衡, 这样kube-apiserver的地址就是`https://10.100.4.20:8443`;
* master节点部署etcd集群、kube-apiserver、kube-schedule、kube-controller-manager; kube-schedule和kube-controller-manager自带高可用功能;
* master也参与到工作中,这样就有5台节点, 其中三台为master;
* coredns暂时部署两个pod,不固定节点;
* ingress部署在master节点上,脚本会自动打标签进去;
* dashboard自主选择节点部署，不再固定节点. dashboard支持用户名和密码登录,默认生成了`kubeadmin`账号,密码为随机密码,密码存放在master节点的`/etc/kubernetes/basic_auth_file`文件中;支持修改密码,但是需要将密码同步到所有master并重启`kube-apiserver`服务.


## 修改的配置信息举例

下面是需要修改的配置,其它没有列出来的配置不需要修改

```
#所有主机的root用户密码,建议设置为统一的密码
export ROOT_PWD="123456"
#需要升级到的内核版本
export Kernel_Version="4.18.9-1"
export KUBE_VERSION="v1.14.8"
# 集群各机器 IP 数组
export NODE_IPS=( 10.100.4.21 10.100.4.22 10.100.4.23 10.100.4.24 10.100.4.25 )
# 集群各 IP 对应的主机名数组
export NODE_NAMES=( k8s-master1 k8s-master2 k8s-master3 k8s-node1 k8s-node2 )
# 集群MASTER机器 IP 数组
export MASTER_IPS=( 10.100.4.21 10.100.4.22 10.100.4.23 )
# 集群所有的master Ip对应的主机
export MASTER_NAMES=(k8s-master1 k8s-master2 k8s-master3 )
# etcd 集群服务地址列表 
export ETCD_ENDPOINTS="https://10.100.4.21:2379,https://10.100.4.22:2379,https://10.100.4.23:2379"
# etcd 集群间通信的 IP 和端口
export ETCD_NODES="k8s-master1=https://10.100.4.21:2380,k8s-master2=https://10.100.4.22:2380,k8s-master3=https://10.100.4.23:2380"
# etcd 集群所有node ip
#定义ETCD集群的节点IP
export ETCD_NODE1="10.100.4.21"
export ETCD_NODE2="10.100.4.22"
export ETCD_NODE3="10.100.4.23"
#这个VIP地址是公用的
export ETCD_VIP="10.100.4.20"   
export ETCD_IPS=(10.100.4.21 10.100.4.22 10.100.4.23 )
# kube-apiserver 的反向代理(kube-nginx)地址端口
export KUBE_APISERVER="https://10.100.4.20:8443"
# 节点间互联网络接口名称
export IFACE="eth0"
# etcd 数据目录
export ETCD_DATA_DIR="/srv/data/k8s/etcd/data"
# etcd WAL 目录，建议是 SSD 磁盘分区，或者和 ETCD_DATA_DIR 不同的磁盘分区
export ETCD_WAL_DIR="/srv/data/k8s/etcd/wal"
# k8s 各组件数据目录
export K8S_DIR="/srv/data/k8s/k8s"
# 最好使用 当前未用的网段 来定义服务网段和 Pod 网段
# 服务网段，部署前路由不可达，部署后集群内路由可达(kube-proxy 保证)
SERVICE_CIDR="10.254.0.0/16"
# Pod 网段，建议 /16 段地址，部署前路由不可达，部署后集群内路由可达(flanneld 保证)
CLUSTER_CIDR="10.200.0.0/16"
# 服务端口范围 (NodePort Range)
export NODE_PORT_RANGE="1024-32767"
# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="10.254.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="10.254.0.2"
# 集群 DNS 域名（末尾不带点号）
export CLUSTER_DNS_DOMAIN="cluster.local"
```

## 安装

```
./install  #输入y确认安装即可,安装过程根据机器配置与网速而定,大概需20分钟左右
```
