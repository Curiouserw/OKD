IMAGE_BASE=docker-registry-default.apps.okd311.curiouser.com/openshift
IMAGE_NAME=backup-es-index-cronjob
IMAGE_VERSION=v1

all: build push

build:
	docker build --rm -f Dockerfile -t ${IMAGE_BASE}/${IMAGE_NAME}:${IMAGE_VERSION} .
push:
	docker push ${IMAGE_BASE}/${IMAGE_NAME}:${IMAGE_VERSION}
