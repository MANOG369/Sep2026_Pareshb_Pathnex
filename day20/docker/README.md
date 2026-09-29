# Day 20 Docker Networking

Create a custom Docker bridge network and run two Ubuntu containers
on the same network.

## Commands

docker network create pathnex-network

docker run -dit --name c1 --network pathnex-network ubuntu
docker run -dit --name c2 --network pathnex-network ubuntu

docker network inspect pathnex-network

docker exec c1 getent hosts c2

docker exec c1 ping -c 3 c2
