docker stop $(docker ps -q --filter name=nextcloud-aio)

docker rm -f $(docker ps -a -q --filter name=nextcloud-aio)
docker volume rm $(docker volume ls -q --filter name=nextcloud_aio)

docker network rm nextcloud_network

