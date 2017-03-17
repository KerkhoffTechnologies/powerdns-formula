{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.repo

recursor:
  pkg.installed:
    - name: {{ powerdns.lookup.pkg_recursor }}
    - refresh_db: True
    - require:
      - sls: powerdns.repo

  service.running:
    - name: {{ powerdns.lookup.service_recursor }}
    - enable: True
    - require:
      - pkg: recursor

recursor_config:
  file.managed:
    - name: {{ powerdns.lookup.config_file_recursor }}
    - source: salt://powerdns/templates/recursor.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: recursor
    - watch_in:
      - service: recursor
