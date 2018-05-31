curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -:
  cmd.run

kubernetes.repo:
  pkgrepo.managed:
    - name: deb http://apt.kubernetes.io/ kubernetes-xenial main
    - dist: kubernetes-xenial
    - file: /etc/apt/sources.list.d/kubernetes.list
    - refresh_db: true
