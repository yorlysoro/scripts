#!/bin/bash
docker buildx prune
docker builder prune -a
docker container prune
docker image prune -a
docker network prune
docker system prune -a
docker volume prune -a
