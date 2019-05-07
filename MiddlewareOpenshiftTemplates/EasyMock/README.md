# EasyMock OKD Template

## 简介
1. 该模板部署的有MongoDB、Redis、EasyMock
2. MongoDB的数据目录进行了PVC(Persistent Volume Claim)持久化。所以您的OKD需要可用的PV（Persistent Volume）
3. EasyMock容器需要有Root权限启动服务，所以创建的有ServiceAccount。因此需要您将该ServiceAccount赋予SCC权限。命令如下：
```shell
oc adm policy add-scc-to-user anyuid -z easy-mock -n easymock所在的Namespace
```
