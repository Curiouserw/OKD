
```bash
oc oc new-project sentry --display-name "Sentry"
oc project sentry
oc exec -it `oc get pod |grep postgresql |awk '{print $1}'` bash
```
进入容器创建`EXTENSION`表
```bash
$ psql
psql (10.5)
Type "help" for help.
	postgres=# \c sentry
		You are now connected to database "sentry" as user "postgres".
	sentry=# CREATE EXTENSION IF NOT EXISTS citext;
```

```bash
oc create -f .
```