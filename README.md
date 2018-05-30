# suck
SaltStack Ubuntu Ceph Kubernetes Madness!

### 1. Install Ubuntu on a bunch of hosts, 4 in my case
All hosts should have static IP addresses. They will act as routers for containers
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
