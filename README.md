# suck
SaltStack Ubuntu Ceph Kubernetes Madness!

### 1. Install Ubuntu on a bunch of hosts, 4 in my case
All hosts should have static IP addresses and should be in the same layer 2 network. They will act as routers for containers
- kubemaster
- kubenode1
- kubenode2
- kubenode3

### 2. Install SaltStack
>All commands below are run as root.
Add a host entry to all systems pointing to kubemaster, our salt master.
```sh
echo 10.7.7.230 salt >> /etc/hosts
```
Install salt minion on all kubenodes
```sh
curl -L https://bootstrap.saltstack.com | sudo sh
```
Install salt minion and master on kubemaster
```sh
curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sh bootstrap-salt.sh -M
```
The minion_id for kubemaster will likely end up as "salt" because of the host entry we added. Set it back to the hostname, kubemaster, to avoid confusion. You only need to run this on kubemaster.
```sh
hostname > /etc/salt/minion_id
service salt-minion restart
rm /etc/salt/pki/master/minions_pre/salt
```
From the salt master, accept all minion keys
```sh
salt-key -A
```
Verify all 4 hosts are connected to the salt master
```sh
salt '*' test.ping
```
#### Optional - Passwordless sudo and aliases for common salt commands
```sh
# As root, replace nickadam with your username
echo 'nickadam    ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/90-nickadam

#As nickadam, or whoever you are
echo "alias salt='sudo salt'" >> .bashrc
echo "alias salt-key='sudo salt-key'" >> .bashrc
echo "alias salt-cp='sudo salt-cp'" >> .bashrc
```
### 3. Clone and edit this repo
```sh
git clone https://github.com/nickadam/suck.git
```
Edit pillar/docker-networks.sls for your environment. The bip (docker bridge ip) and network are sized to allow up to 63 kubenodes and a maximum of 1022 container IPs each. That's a hell of a lot of hosts. If you need more than this, good luck. I look forward to your writeup. 😉
```yaml
kubemaster:
  bip: 172.18.0.1/22
  network: 172.18.0.0/22
  gateway: 10.7.7.230
kubenode1:
  bip: 172.18.4.1/22
  network: 172.18.4.0/22
  gateway: 10.7.7.231 
kubenode2:
  bip: 172.18.8.1/22
  network: 172.18.8.0/22
  gateway: 10.7.7.232
kubenode3:
  bip: 172.18.12.1/22
  network: 172.18.12.0/22
  gateway: 10.7.7.233
```
To address and subnet additional nodes for a /22 network, count in binary for the network bits in the third octet. Effectively, your just counting by 4 in the third octet.
```
128 64 32 16 8 4
  0  0  0  0 0 0 = 0, 172.18.0.1/22

128 64 32 16 8 4
  0  0  0  0 0 1 = 4, 172.18.4.1/22

128 64 32 16 8 4
  0  0  0  0 1 0 = 8, 172.18.8.1/22

128 64 32 16 8 4
  0  0  0  0 1 1 = 4, 172.18.12.1/22

128 64 32 16 8 4
  0  0  0  1 0 0 = 4, 172.18.16.1/22
  
128 64 32 16 8 4
  0  0  0  1 0 1 = 4, 172.18.20.1/22  

128 64 32 16 8 4
  0  0  0  1 1 0 = 4, 172.18.24.1/22  

...and so on... 
```
