# Day 17 Docker - MySQL

## Run MySQL

```bash
docker run -d \
  --name pathnex-mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:8
