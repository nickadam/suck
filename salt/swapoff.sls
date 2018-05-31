vm.swappiness:
  sysctl.present:
    - value: 0

swapoff -a:
  cmd.run
