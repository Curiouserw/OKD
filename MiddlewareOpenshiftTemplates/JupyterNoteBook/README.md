# Jupyter NoteBook On Openshift

# 说明
radanalytics.io公司在Openshift上的部署说明：https://radanalytics.io/examples/var

# Openshift 部署步骤
1. 创建openshift项目

         oc new-project jupyter --display-name="Jupyter NoteBook"
2. 创建Jupyter项目

        oc new-app radanalyticsio/workshop-notebook -e JUPYTER_NOTEBOOK_PASSWORD=curiouser
3. 创建route

        oc expose svc/workshop-notebook

