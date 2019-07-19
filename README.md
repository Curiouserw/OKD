# Template 编写原则

#### 1. 指定版本镜像的Container，拉取策略尽量使用IfNotPresent。使用latest版本镜像的Container，再使用Always
```yaml
imagePullPolicy: IfNotPresent
imagePullPolicy: Always
```

#### 2. 如果同一个Template中部署的服务间有安装前后的依赖时，加InitContainer

```yaml
initContainers:
- name: init-scheduler
  image: docker.io/busybox:latest
  imagePullPolicy: IfNotPresent
  command: ['sh', '-c', 'until nc -znv ${APPLICATION_NAME}-redis 6379 ; do echo waiting for ${APPLICATION_NAME}-postgresql to be up; sleep 5; done;']
  restartPolicy: Always
```

#### 3. 对于需要特殊权限运行的服务，添加自己的ServiceAccount和SecurityContextConstraints
ServiceAccount
```yaml
kind: ServiceAccount
apiVersion: v1
metadata:
  name: "${APPLICATION_NAME}-user" 
```
SecurityContextConstraints
```yaml
kind: SecurityContextConstraints
apiVersion: security.openshift.io/v1
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: true
allowPrivilegedContainer: false
allowedCapabilities: null
defaultAddCapabilities: null
fsGroup:
  type: RunAsAny
groups:
  - system:cluster-admins
metadata:
  annotations:
    kubernetes.io/description: anyuid provides all features of the restricted SCC
      but allows users to run with any UID and any GID.
  name: "${NAMESPACE}-${APPLICATION_NAME}-anyuid"
priority: 10
readOnlyRootFilesystem: false
requiredDropCapabilities:
  - MKNOD
runAsUser:
  type: RunAsAny
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
users:
  - system:serviceaccount:${NAMESPACE}:${APPLICATION_NAME}-user
volumes:
  - configMap
  - downwardAPI
  - emptyDir
  - persistentVolumeClaim
  - projected
  - secret
```
#### 4. 对于需要显示一些部署后的信息和模板描述信息的Template，添加message和description属性
```yaml
apiVersion: v1
kind: Template
metadata:
  name: openldap-phpldapadmin
  annotations:
    description: |-
      .......
      Note: ......
      ....... 
      tags: Tag1,Tag2
message: |-
        .......
        User admin Password: ${ADMIN_PASSWORD}
        Connection URL: ldap://${APPLICATION_NAME}-service.${NAMESPACE}.svc:389
        ....... 
```
#### 5. 涉及到密码的环境变量以Secret的形式注入容器
Secret
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: ${APPLICATION_NAME}-config-env
stringData:
  LDAP_ADMIN_PASSWORD: ${OPENLDAP_ADMIN_PASSWORD}
  LDAP_READONLY_USER_PASSWORD: ${OPENLDAP_READONLY_USER_PASSWORD}
```
Deployment中使用
```yaml
containers:
  envFrom:
    - secretRef:
        name: ${APPLICATION_NAME}-config-env
```

#### 6. 所有的Template都要添加健康检查和资源限制

