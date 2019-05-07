# Spring Boot应用基础模板镜像
## 镜像说明
<pre>
适用场景：适用于Maven打包后，Java -jar就能运行的应用（Jar包中内置Tomcat的应用）。
镜像中安装的软件及版本：
         JDK：1.8.171
         Maven：3.5.3
         额外工具：telnet net-tools wget
镜像系统设置：
         时区：Asia/Shanghai
         系统语言：en_US.UTF-8
镜像暴露端口：8080
</pre>
## 目录结构及文件说明
<pre>
|-s2i/bin/assemble       : 构建build时脚本，该脚本配置了如何使用Maven将源代码构建成可运行的Target jar包。
|       |-run            : 部署Deploy时脚本，该脚本配置了如何在Deploy阶段java -jar运行Target jar包。
|       |-usage          : 镜像EntryPoint使用的脚本文件（可在里面定义一些使用使用镜像使用说明）。
|-Dockerfile             : 该Dockerfile文件中定义了使用哪个基础镜像，如何安装配置Maven、JDK及其他常用工具，创建用户或目录等操作。
|-apache-maven-3.5.3-bin.tar : 该文件只是一个文本文件，实际构建中下载真实的Maven tar进行替换。
|-settings               : Maven的配置文件，其中定义了镜像中maven的配置（如设置maven私库地址）。
|-jdk-8u171-linux-x64.tar: 该文件只是一个文本文件，实际构建中下载真实的JDK tar进行替换。
|-repository.tar         : 该文件只是一个文本文件，实际构建中将一些常用依赖Jar包打成tar包，放到settings文件指定的本地Maven jar包仓库中，以减少s2i构建打包时间。
</pre>
## 应用基础模板镜像构建步骤
#### 1.拉取源代码并切换路径到该路径下。
<pre>
git clone https://github.com/RationalMonster/OpenShift.git OpenShift -b master ;\
cd OpenShift/ApplicationTemplates/s2i-JavaMaven/Image
</pre>
#### 2.Docker build命令构建镜像。
<pre>
docker build -t JavaMaven:v1 .
</pre>
#### 3.给镜像打上私有镜像注册仓库的tag并推送上去。
<pre>
docker tag JavaMaven:v1 私有镜像注册仓库URL/镜像库名/JavaMaven:v1 ;\
docker push 私有镜像注册仓库URL/镜像库名/JavaMaven:v1
</pre>

## 镜像中s2i/bin/{assemble、run}构建部署脚本中预留的环境变量
#### s2i/bin/assemble
 - MVN_ARGS   : 指定源代码根目录中父POM文件的相对路径。变量设置格式："-f 父POM文件相对路径"。
 - APP_TARGET : 指定源代码maven构建生产的target jar包的根路径，默认值源代码根目录的target目录下。
#### s2i/bin/run
 - JVM_OPTS  ： 用于设置应用POD运行时JVM的参数，可配置所有JVM参数。
 - JAVA_OPTS ： 用于设置应用POD运行时传递给应用的参数，可设置Jar包运行时使用哪个环境的配置文件
