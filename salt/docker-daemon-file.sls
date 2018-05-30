/etc/docker/daemon.json:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://docker-daemon.json
    - template: jinja
