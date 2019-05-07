# Spring MVC应用基础模板镜像
## 镜像说明
<pre>
适用场景：适用于使用Maven将源代码打成WAR包后，放到Tomcat容器中运行的应用
镜像中安装的软件及版本：
         JDK：1.8.111
         Maven：3.3.3
         Tomcat：8.5.20
         额外工具：telnet net-tools wget
镜像系统设置：
         时区：Asia/Shanghai
         系统语言：en_US.UTF-8
镜像暴露端口：8080
</pre>
## 目录结构及文件说明
<pre>
|-s2i/bin/assemble       : 构建build时脚本，该脚本配置了如何使用Maven将源代码构建成War包。
|       |-run            : 部署Deploy时脚本，该脚本配置了如何在Deploy阶段使用catalina.sh前台启动Tomcat。
|       |-usage          : 镜像EntryPoint使用的脚本文件（可在里面定义一些使用使用镜像使用说明）。
|-Dockerfile             : 该Dockerfile文件中定义了使用哪个基础镜像，如何安装配置Maven、JDK、Tomcat及其他常用工具，创建用户或目录等操作。
|-apache-maven-3.3.3.tar : 该文件只是一个文本文件，实际构建中下载真实的Maven tar进行替换。
|-settings               : Maven的配置文件，其中定义了镜像中maven的配置（如设置maven私库地址）。
|-jdk-8u111-linux-x64.tar: 该文件只是一个文本文件，实际构建中下载真实的JDK tar进行替换。
|-apache-tomcat-8.5.20.tar.gz: 该文件只是一个文本文件，实际构建中下载真实的Tomcat tar进行替换。
</pre>
## 应用基础模板镜像构建步骤
#### 1.拉取源代码并切换路径到该路径下。
<pre>
git clone https://github.com/RationalMonster/OpenShift.git OpenShift -b master ;\
cd OpenShift/ApplicationsBasisImages/JavaMavenTomcat
</pre>
#### 2.Docker build命令构建镜像。
<pre>
docker build -t JavaMavenTomcat:v1 .
</pre>
#### 3.给镜像打上私有镜像注册仓库的tag并推送上去。
<pre>
docker tag JavaMavenTomcat:v1 私有镜像注册仓库URL/镜像库名/JavaMavenTomcat:v1 ;\
docker push 私有镜像注册仓库URL/镜像库名/JavaMavenTomcat:v1
</pre>

## 镜像中s2i/bin/assemble构建脚本中预留的环境变量
#### s2i/bin/assemble
 - MVN_ARGS   : 指定源代码根目录中父POM文件的相对路径。变量设置格式："-f 父POM文件相对路径"。
 - APP_TARGET : 指定源代码maven构建生产的target war包的根路径，默认值为源代码根目录的target文件下。

