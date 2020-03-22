#!/bin/bash
echo ">>>>>> 正在部署KeepLived <<<<<<"
source ./conf/environment.conf
for node_ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "yum install -y keepalived"
  done

source ./conf/environment.conf
cat > ./work/keepalived.conf <<EOF
! Configuration File for keepalived
global_defs {
   router_id 192.168.0.50
}
vrrp_script chk_nginx {
    script "/etc/keepalived/check_port.sh 8443"
    interval 2
    weight -20
}
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 251
    priority 100
    advert_int 1
    mcast_src_ip 192.168.0.50
    nopreempt
    authentication {
        auth_type PASS
        auth_pass 11111111
    }
    track_script {
         chk_nginx
    }
    virtual_ipaddress {
        $ETCD_VIP
    }
}
EOF

echo "正在修改keepalived配置"
source ./conf/environment.conf
for node_ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${node_ip}"
    scp -r ./work/keepalived.conf root@${node_ip}:/etc/keepalived/keepalived.conf
    scp -r ./bin/check_port.sh  root@${node_ip}:/etc/keepalived/
    ssh root@${node_ip} "chmod +x /etc/keepalived/check_port.sh"
    ssh root@${node_ip} "sed -i 's#192.168.0.50#${node_ip}#g'  /etc/keepalived/keepalived.conf"
  done

echo "正在启动keepalived"
source ./conf/environment.conf
for node_ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "systemctl enable --now keepalived"
  done
  
sleep 10s


echo "======================="
echo "keepalived服务安装完成"
echo "======================="

