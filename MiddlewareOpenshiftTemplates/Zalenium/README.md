
# Zalenium 自动化UI测试工具
## 目录结构及文件说明
1. zalenium-template.yml  open shift上的部署脚本
2. *.py 测试示例文件

# zalenium在openshift上的部署过程
1. openshift上创建项目
        
        oc new-project zalenium --display-name="Zalenium"
2. 导入zalenium-template.yml模板文件(模板文件源地址：https://github.com/zalando/zalenium/blob/master/docs/k8s/zalenium-template.yaml)
    
        oc create -f zalenium-template.yml -n opesnhift
3. 查看模板中的参数

        oc  process --parameters zalenium -n zalenium
        NAME                                 DESCRIPTION                                                                                                                                     GENERATOR           VALUE
        PROJECT_NAME                                                                                                                                                                                             
        DESIRED_CONTAINERS                   This is the number of containers that should be created when Zalenium starts up.                                                                                    2
        MAX_DOCKER_SELENIUM_CONTAINERS       This is the maximum number of docker selenium containers that can be running at any one time.                                                                       10
        MAX_TEST_SESSIONS                    This is the number of max amount of tests executed per container/pod.                                                                                               4
        ZALENIUM_KUBERNETES_CPU_REQUEST      This is the minimum amount of CPU that the Zalenium container will be allocated.                                                                                    500m
        ZALENIUM_KUBERNETES_CPU_LIMIT        This is the maximum amount of CPU that the Zalenium container will be allowed to use.                                                                               1000m
        ZALENIUM_KUBERNETES_MEMORY_REQUEST   This is the minimum amount of memory that the Zalenium container will be allocated.                                                                                 500Mi
        ZALENIUM_KUBERNETES_MEMORY_LIMIT     This is the maximum amount of memory that the Zalenium container will be allowed to use, it will be terminated if it exceeds this limit.                            2Gi
        SELENIUM_KUBERNETES_CPU_REQUEST      This is the minimum amount of CPU that each selenium container will be allocated.                                                                                   250m
        SELENIUM_KUBERNETES_CPU_LIMIT        This is the maximum amount of CPU that each selenium container will be allowed to use.                                                                              1000m
        SELENIUM_KUBERNETES_MEMORY_REQUEST   This is the minimum amount of memory that the each selenium container will be allocated.                                                                            250Mi
        SELENIUM_KUBERNETES_MEMORY_LIMIT     This is the maximum amount of memory that the each selenium container will be allowed to use, it will be terminated if it exceeds this limit.                       2Gi
        VOLUME_CAPACITY                      The volume is used to store all the test results, including logs and video recordings of the tests.                                                                 10Gi
        ZALENIUM_USER                        This username is used to authenticate towards the Selenium Hub URL (leave blank if you do not want authentication).                                                 zalenium
        ZALENIUM_PASSWORD                    This password is used to authenticate towards the Selenium Hub URL (leave blank if you do not want authentication).                             expression          [a-zA-Z0-9]{16}
        SEND_ANONYMOUS_USAGE_INFO            Set to false if you do not want to send statistics back to Zalando.                                                                                                 true     
4. 处理模板文件
    
        oc process openshift/zalenium \
        -p  PROJECT_NAME=zalenium \
        -p  DESIRED_CONTAINERS=2 \
        -p  VOLUME_CAPACITY=5GB \
        -p  ZALENIUM_USER="" \
        -p  ZALENIUM_PASSWORD="" \
        -p  SEND_ANONYMOUS_USAGE_INFO=true \
        |oc create -f -      
5. 使用ceph作为pvc的后端动态pv，先给该项目创建secret

        oc  create secret generic ceph-secret --type="kubernetes.io/rbd" --from-literal=key='**********' --namespace=zalenium
6. 此时zalenium项目中的pod:zalenium是起不来。因为pvc正在pending。删除掉pending的pvc，手动创建名为zalenium-pvc、使用ceph storage class，access-mode为RWO (Read-Write-Once)的pvc。

        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
          name: zalenium-pvc
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 5Gi
          storageClassName: ceph-rbd-sc             
7. 部署成功后

![](https://github.com/RationalMonster/OpenShift/blob/master/MiddlewareOpenshiftTemplates/Zalenium/pictures/20180623181045.png)
## 其他相关domain
http://$zalenium-router/grid/admin/live </br>
http://$zalenium-router/dashboard/</br>


# 测试示例文件的执行过程
1. python 安装selenium插件
        
        pip install selenium
2. 修改示例文件中zalenium的连接信息

3. 执行示例文件

        python demo2.py
4. dashboard显示执行结果记录
![](https://github.com/RationalMonster/OpenShift/blob/master/MiddlewareOpenshiftTemplates/Zalenium/pictures/20180623184626.jpg)

5. 实时执行结果页面
![](https://github.com/RationalMonster/OpenShift/blob/master/MiddlewareOpenshiftTemplates/Zalenium/pictures/20180623184921.png)
# 优化
1. 修改时区</br>
   在openshift zalenium project中修改dc,添加环境变量TZ=Asia/Shanghai   
2. 设空Selenium Hub URL的认证</br>
   在openshift zalenium project中修改dc，删除环境变量ZALENIUM_USER和ZALENIUM_PASSWORD,然后重新部署。
# Selenium IDE的安装与使用
1. 浏览器安装Selenium IDE插件的安装（以火狐浏览器为例）
搜索扩展里面下载安装，过程省略。
2. 使用
