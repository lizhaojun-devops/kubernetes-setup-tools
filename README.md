# kubernetes自动部署工具

## 如何使用
* 找个虚拟机,能够远程ssh你的k8s节点地址的作为部署机器,远程进行部署

## 内网版本部署

* 适合用于公司内快速安装,所有资源均存放于内网服务器上,不用从外网获取,安装速度快; 但不适用于公司外安装!
* `注意:使用该方式在内网部署k8s集群时能够和172.19.2.252服务器能够正常通信,否则因下载不了安装包安装失败`

[安装教程](http://git.tophc.top/kubernetes/kubernetes-setup-tools/tree/intranet)

## 外网版本

* 适合用于公司外进行安装,基础的`image`选择了从阿里云镜像站获取,能够增加下载速度减少安装耗时.

[安装教程](http://git.tophc.top/kubernetes/kubernetes-setup-tools/tree/global)


