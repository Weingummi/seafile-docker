#!/bin/sh

cd `dirname $0`

ARCH=`uname -m`
IMAGE="seafile"
VERSION="6.2.4"

if `echo $ARCH | grep -q arm`; then
	#Use armhf/alpine as base image instead of alpine
	sed -r 's,(FROM)\s+(alpine),\1 armhf/\2,;s,(SEAFILE_VERSION=")[0-9.]*("),\1'$VERSION'\2,' < ./docker/Dockerfile > ./docker/Dockerfile.arm

	docker build -t ${IMAGE}:${VERSION} -f ./docker/Dockerfile.arm ./docker/
	#&& rm -rf ./build
else
	if `echo $ARCH | grep -q x86_64`; then
		sed -r -i 's,(SEAFILE_VERSION=")[0-9.]*("),\1'$VERSION'\2,' ./docker/Dockerfile
		docker build -t ${IMAGE}:${VERSION} ./docker/
	else 
		echo "Error: Architecture $ARCH isn't supported"
		exit 1
	fi
fi

