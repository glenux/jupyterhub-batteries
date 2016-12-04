#!/bin/sh 

mkdir -p tmp/apt
docker build -t jupyterhub-batteries .
docker run \
	-p 8000:8000 \
	--rm \
	--name jupyterhub \
	jupyterhub-batteries

# --volume "/var/cache/apt/archives:tmp/apt"
