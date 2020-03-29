#/bin/bash
echo ">>>>>> 开始安装 docker 组件 <<<<<<"
source ./conf/environment.conf

for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
    ssh root@${node_ip} "yum install -y yum-utils device-mapper-persistent-data lvm2; yum makecache; yum -y install docker-ce; chkconfig docker on"
    ssh root@${node_ip} "mkdir /etc/systemd/system/docker.service.d"
    ssh root@${node_ip} "mkdir -p /etc/docker/; "
    ssh root@${node_ip} "mkdir -p /srv/data"
    ssh root@${node_ip} "rm -rf /var/lib/docker"
    ssh root@${node_ip} "rm -rf /srv/data/docker"
    scp ./conf/docker.service root@${node_ip}:/usr/lib/systemd/system/docker.service 
    scp ./conf/daemon.json root@${node_ip}:/etc/docker/daemon.json
    # 代理配置暂时忽略
    #scp ./conf/http-proxy.conf root@${node_ip}:/etc/systemd/system/docker.service.d/http-proxy.conf
    ssh root@${node_ip} "systemctl daemon-reload; systemctl stop docker; systemctl restart docker; docker info"
  done


for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "systemctl status docker|grep Active"
  done

for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "/usr/sbin/ip addr show flannel.1 && /usr/sbin/ip addr show docker0"
  done


echo "docker安装完成"
