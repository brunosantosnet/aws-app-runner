#!/bin/sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1.dkr.ecr.us-east-1.amazonaws.com
docker build -t myrepo . 
docker tag myrepo:latest $1.dkr.ecr.us-east-1.amazonaws.com/myrepo:latest 
docker push $1.dkr.ecr.us-east-1.amazonaws.com/myrepo:latest
