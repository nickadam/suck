/etc/docker-routes:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/docker-routes/routes.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://docker-routes.conf
    - template: jinja

/usr/local/sbin/docker-routes:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://docker-routes

/etc/systemd/system/docker-routes.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://docker-routes.service

docker-routes:
  service.enabled

docker-routes start:
  cmd.run

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

docker-iptables:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - destination: '! {{ pillar['docker-network'] }}'
    - out-interface: {{ pillar['docker-networks'][grains['id']]['gateway-dev'] }}
    - jump: MASQUERADE

iptables-save > /etc/iptables/rules.v4:
  cmd.run
