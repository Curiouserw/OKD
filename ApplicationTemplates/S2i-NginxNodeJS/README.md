# 前端NodeJS应用基础模板镜像
## 镜像说明
<pre>
适用场景：使用npm 命令进行下载依赖包并生成静态资源文件的前后端分离的纯前端应用，该镜像中使用Nginx作为
	 前端静态资源服务器，需要将Nginx配置文件放入源代码的根目录。
镜像中安装的软件及版本：
         Node：8.9.4
         Nginx：1.12.2（使用YUM安装的）
         额外工具：telnet wget net-tools vim
镜像系统设置：
         时区：Asia/Shanghai
         系统语言：en_US.UTF-8
镜像暴露端口：8080
Node设置：
      nodejs镜像源 ： https://registry.npm.taobao.org
      sass_binary_site : https://npm.taobao.org/mirrors/node-sass
Nginx配置文件中的一些目录说明：
      /data/apps： 虚拟主机root目录，该路径下要放置的是在源代码根目录下通过npm run命令生成的静态资源文件夹dist目录。
      /data/apps/nginx：该目录存放nginx的日志、PID等文件。
</pre>
## 目录结构及文件说明
<pre>
|-s2i/bin/assemble          : 构建build时脚本，该脚本配置了如何使用npm install命令下载依赖仓库，
                              如何使用npm run将源代码构建成静态资源文件。
|       |-run               : 部署Deploy时脚本，该脚本配置了Nginx 的启动命令,以tail -f 查看nginx访问日志为POD的EntryPoint。
|       |-usage             : 镜像EntryPoint使用的脚本文件（可在里面定义一些使用使用镜像使用说明）。
|-Dockerfile                : 该Dockerfile文件中定义了使用哪个基础镜像，如何安装配置Node、Nginx及其他常用工具，
                              创建用户或目录，从源代码中拉取Nginx配置文件等操作。
|-node-v8.9.4-linux-x64.tar : 该文件只是一个文本文件，实际构建中下载真实的Node tar包进行替换。
|-nginx.repo                : 在镜像系统中添加Nginx的YUM源，方便使用YUM安装Nginx。
</pre>
## 应用基础模板镜像构建步骤
#### 1.拉取源代码并切换路径到该路径下。
<pre>
git clone https://github.com/RationalMonster/OpenShift.git OpenShift -b master ;\
cd OpenShift/ApplicationsBasisImages/NodeJS
</pre>
#### 2.Docker build命令构建镜像。
<pre>
docker build -t NodeJS:v1 .
</pre>
#### 3.给镜像打上私有镜像注册仓库的tag并推送上去。
<pre>
docker tag NodeJS:v1 私有镜像注册仓库URL/镜像库名/NodeJS:v1 ;\
docker push 私有镜像注册仓库URL/镜像库名/NodeJS:v1
</pre>

## 镜像中s2i/bin/assemble构建部署脚本中预留的环境变量
#### s2i/bin/assemble
 - NPM\_INSTALL\_ARGS   : 给npm install 命令预留的参数。（该值最好设置为）
 - NPM\_RUN\_ARGS : 给npm run 命令预留的参数。
