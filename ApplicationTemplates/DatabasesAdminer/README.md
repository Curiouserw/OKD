#  The Openshift Template for PHP Adminer which is databases management tool

## 说明
由于在openshift中容器化的数据库，例如MySQL，MongoDB，Postgresql等。无法在集群外部使用客户端通过TCP 3306端口连接进行数据操纵（原因是service的ClusterIP，集群外部无法识别）。一次在容器化国产项目管理工具禅道的时候，发现其中有个工具Adminer可以在PHP页面上对数据库进行操作。所以为什么不可以将PHP Adminer容器化放到openshift集群中,让他通过service的svc地址直接访问数据库呢！
## 使用步骤：
1. 构建Adminer镜像并推送到私有镜像仓库中 

        git clone https://github.com/RationalMonster/OpenShift.git -b master ~/openshift;\
        cd ~/openshift/ApplicationTemplates/DatabasesAdminer/Image ;\
        docker build -t docker-registry.default.svc:5000/databasesadminer/databasesadminer:4.2.4 .;\
        docker push docker-registry.default.svc:5000/databasesadminer/databasesadminer:4.2.4
        
2. 导入模板文件到openshift项目中
     
        oc create -f   ~/openshift/ApplicationTemplates/DatabasesAdminer/DatabasesAdminer-template.yml -n openshift
3. 给POD中授予以root运行的权限

        oc adm policy add-scc-to-user anyuid -z databasesadminer-user -n 部署adminer的项目名
4. 在项目中部署模板。</br>
![](https://github.com/RationalMonster/OpenShift/blob/master/ApplicationTemplates/DatabasesAdminer/Pictures/%E6%A8%A1%E6%9D%BF.jpg)
![](https://github.com/RationalMonster/OpenShift/blob/master/ApplicationTemplates/DatabasesAdminer/Pictures/%E8%AE%BF%E9%97%AEAdminer%E8%AE%A4%E8%AF%81%E9%99%90%E5%88%B6.jpg)
![](https://github.com/RationalMonster/OpenShift/blob/master/ApplicationTemplates/DatabasesAdminer/Pictures/%E6%95%B0%E6%8D%AE%E5%BA%93%E8%BF%9E%E6%8E%A5.jpg)
![](https://github.com/RationalMonster/OpenShift/blob/master/ApplicationTemplates/DatabasesAdminer/Pictures/%E6%95%B0%E6%8D%AE%E5%BA%93.jpg)
