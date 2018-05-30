docker-network:
  172.18.0.0/16

docker-networks:
  kubemaster:
    bip: 172.18.0.1/22
    network: 172.18.0.0/22
    gateway: 10.7.7.230
    gateway-dev: eth0
  kubenode1:
    bip: 172.18.4.1/22
    network: 172.18.4.0/22
    gateway: 10.7.7.231
    gateway-dev: eth0
  kubenode2:
    bip: 172.18.8.1/22
    network: 172.18.8.0/22
    gateway: 10.7.7.232
    gateway-dev: eth0
  kubenode3:
    bip: 172.18.12.1/22
    network: 172.18.12.0/22
    gateway: 10.7.7.233
    gateway-dev: eth0
