# Openshift部署禅道
# 说明
#### 1. 版本
- MySQL 5.5  
- 禅道 9.3.beta（公司虚机上的版本）
- PHP 5.6.36
- Apache 2.2.15
#### 2. 初始化用户密码
- 禅道管理员admin用户的密码：*****（部署成功后请及时修改admin密码）
#### 3. 模板中创建的openshift资源对象
      Secret                      mysql-zentao
      Route                       zentao
      Service                     mysql
      Service                     zentao
      PersistentVolumeClaim       zentao-data
      PersistentVolumeClaim       mysql-data
      ServiceAccount              mysql
      ServiceAccount              zentao
      DeploymentConfig            mysql
      DeploymentConfig            zentao
# 部署步骤
1. Openshift创建项目

        oc new-project zentao --display-name="Zentao"
2. (可选)在项目中创建Ceph的secret。备注：模板中声明的PVC是Ceph类型的，后端持久化存储PV使用的是Ceph，所以需要提前创建Ceph的Secret。

        oc  create secret generic ceph-secret --type="kubernetes.io/rbd" --from-literal=key='****' --namespace=zentao
3. 将模板中创建的ServiceAccount加入到scc anyuid中，使容器以root用户运行其中的命令

        oc adm policy add-scc-to-user anyuid -z zentao -n zentao
4. 构建禅道的基础镜像并推送到私有仓库中(以构建禅道10.4.stable为例)

        git clone https://github.com/RationalMonster/OpenShift.git -b master ~/openshift;\
        cd ~/openshift/ApplicationTemplates/Zentao/Image/10.4.stable ;\
        docker build -t docker-registry.default.svc:5000/zentao/zentao:10.4.stable .;\
        docker push docker-registry.default.svc:5000/zentao/zentao:10.4.stable  
5. 导入禅道的模板文件

        oc create -f ~/openshift/ApplicationTemplates/Zentao/zentao-template.yml


