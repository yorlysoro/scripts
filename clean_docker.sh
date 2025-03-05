#!/bin/bash
docker buildx prune
docker builder prune
docker container prune
docker image prune
docker network prune
docker system prune
docker volume prune
