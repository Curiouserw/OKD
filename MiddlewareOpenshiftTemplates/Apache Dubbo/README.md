

# 镜像说明：
1. 修改了zookeeper的启动脚本，使其能够在前台启动
2. 修改了zookeeper的默认数据目录
3. 修改了dubbo运行Jar中默认的日志输出方式，去掉输出到文件，只保留输出到Console
4. 以非Root用户启动容器中的服务
5. 该镜像中包含Zookeeper和Dubbo两种服务，只需要在启动容器的时候指定不同的命令。
6. 启动命令
zookeeper
```shell
docker run -it docker.io/curiouser/dubbo_zookeeper:v1 zkServer.sh start
```
duboo
```shell
docker run -it -e ZOOKEEPER_SERVICE=Zookeeper容器的地址加端口  docker.io/curiouser/dubbo_zookeeper:v1 java -jar /opt/dubbo-admin-0.1.jar
#ZOOKEEPER_SERVICE 示例：172.17.0.5:2181
```
# 部署在Openshift上模板说明
1. Zookeeper未做持久。如需持久化，请挂载持久化卷容器的/home/noroot/data
