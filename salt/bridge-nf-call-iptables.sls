modprobe br_netfilter:
  cmd.run

net.bridge.bridge-nf-call-iptables:
  sysctl.present:
    - value: 1
