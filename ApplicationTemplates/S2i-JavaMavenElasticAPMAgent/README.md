# Spring Boot应用基础模板镜像
## 镜像说明
```shell
适用场景：适用于Maven打包后，Java -jar就能运行的应用（Jar包中内置Tomcat的应用）。
镜像中安装的软件及版本：
         JDK：1.8.171
         Maven：3.5.3
         系统工具：telnet net-tools wget
镜像系统设置：
         时区：Asia/Shanghai
         系统语言：en_US.UTF-8
镜像暴露端口：8080
Maven默认使用的是Aliyun的Maven仓库
```
## 目录结构及文件说明
```shell
|-s2i/bin/assemble       : 构建build时脚本，该脚本配置了如何使用Maven将源代码构建成可运行的Target jar包。
|       |-run            : 部署Deploy时脚本，该脚本配置了如何在Deploy阶段java -jar运行Target jar包。
|       |-usage          : 镜像EntryPoint使用的脚本文件（可在里面定义一些使用使用镜像使用说明）。
|-Dockerfile             : 该Dockerfile文件中定义了使用哪个基础镜像，如何安装配置Maven、JDK及其他常用工具，创建用户或目录等操作。
|-apache-maven-3.5.3-bin.tar : 该文件只是一个文本文件，实际构建中下载真实的Maven tar进行替换。
|-settings               : Maven的配置文件，其中定义了镜像中maven的配置（如设置maven私库地址）。
|-jdk-8u171-linux-x64.tar: 该文件只是一个文本文件，实际构建中下载真实的JDK tar进行替换。
|-repository.tar         : 该文件只是一个文本文件，实际构建中将一些常用依赖Jar包打成tar包，放到settings文件指定的本地Maven jar包仓库中，以减少s2i构建打包时间。
|-US_export_policy.jar   : 因为某些国家的进口管制限制，Java发布的运行环境包中的加解密有一定的限制。比如默认不允许256位密钥的AES加解密，解决方法就是修改策略文件
|-local_policy.jar       : JDK JCE 
```
## 应用基础模板镜像构建步骤
#### 1. 拉取源代码并切换路径到该路径下。
```shell
git clone https://github.com/RationalMonster/OpenShift.git OpenShift -b master ;\
cd OpenShift/ApplicationTemplates/s2i-JavaMaven/Image
```
#### 2. Docker build命令构建镜像。
```shell
docker build -t JavaMaven:v1 .
```
#### 3. 使用S2I镜像构建从源代码构建自己的应用docker镜像
S2I安装下载。Github：https://github.com/openshift/source-to-image
```jshelllanguage
$  s2i -h
Source-to-image (S2I) is a tool for building repeatable docker images.

A command line interface that injects and assembles source code into a docker image.
Complete documentation is available at http://github.com/openshift/source-to-image

Usage:
  s2i [flags]
  s2i [command]

Available Commands:
  build       Build a new image
  completion  Generate completion for the s2i command (bash or zsh)
  create      Bootstrap a new S2I image repository
  rebuild     Rebuild an existing image
  usage       Print usage of the assemble script associated with the image
  version     Display version

Flags:
      --ca string        Set the path of the docker TLS ca file (default "/root/.docker/ca.pem")
      --cert string      Set the path of the docker TLS certificate file (default "/root/.docker/cert.pem")
      --key string       Set the path of the docker TLS key file (default "/root/.docker/key.pem")
      --loglevel int32   Set the level of log output (0-5)
      --tls              Use TLS to connect to docker; implied by --tlsverify
      --tlsverify        Use TLS to connect to docker and verify the remote
  -U, --url string       Set the url of the docker socket to use (default "unix:///var/run/docker.sock")

Use "s2i [command] --help" for more information about a command.
```
Example
```jshelllanguage
$ s2i build  \
-e MVN_ARGS='-f service/pom.xml' \
-e APP_TARGET='./service/' \
ssh://git@gitlab-hosts/Demo/sample.git \  
JavaMaven:v1 \
demo_applications_springboot2:v1
```
或者在本地源代码根路径下
```jshelllanguage
s2i  build . JavaMaven:v1 demo_applications_springboot2:v1 
```
#### 4. 运行应用的Dockers镜像
```jshelllanguage
docker run -it -e JAVA_OPTS="--spring.profile.active=dev" demo_applications_springboot2:v1
```
带着Elastic APM Agent运行
```jshelllanguage
docker run -it \
-e JAVA_OPTS="--spring.profile.active=dev" \
-e JVM_OPTS='-Xmx1500M -Xms800M -javaagent:/opt/apm/elastic-apm-agent-1.7.0.jar -Delastic.apm.service_name=demo-springboot2-dev -Delastic.apm.server_urls=http://localhost:8081 -Delastic.apm.application_packages=com.curiouser' \
demo_applications_springboot2:v1
```
## Note 
镜像中s2i/bin/{assemble、run}构建部署脚本中预留的环境变量
#### s2i/bin/assemble
 - MVN_ARGS   : 指定源代码根目录中父POM文件的相对路径。变量设置格式："-f 父POM文件相对路径"。
 - APP_TARGET : 指定源代码maven构建生产的target jar包的根路径，默认值源代码根目录的target目录下。
#### s2i/bin/run
 - JVM_OPTS  ： 用于设置应用POD运行时JVM的参数，可配置所有JVM参数。
 - JAVA_OPTS ： 用于设置应用POD运行时传递给应用的参数，可设置Jar包运行时使用哪个环境的配置文件
