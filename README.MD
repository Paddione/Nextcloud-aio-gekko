/etc/docker/daemon.json
{
    "ipv6": true,
    "fixed-cidr-v6": "fd00::/80",
    "experimental": true,
    "ip6tables": true,
    "default-address-pools": [
        {
            "base": "172.17.0.0/16",
            "size": 24
        },
        {
            "base": "172.18.0.0/16",
            "size": 24
        }
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}

docker network create \
  --driver=bridge \
  --ipv6 \
  --subnet=172.20.0.0/16 \
  --gateway=172.20.0.1 \
  --subnet=fd01::/80 \
  --gateway=fd01::1 \
  nextcloud_network

mkdir -p config/mastercontainer
mkdir -p config/npm/{data,letsencrypt}
