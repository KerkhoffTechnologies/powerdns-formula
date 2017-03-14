{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.config

powerdns_install_sqlite3:
  pkg.installed:
    - name: {{ powerdns.lookup.backend_sqlite3_pkg }}
    - require:
      - pkg: powerdns

powerdns_config_sqlite3:
  file.managed:
    {## Using .get below because direct access fails on the include keyword ##}
    - name: {{ powerdns.config.get('include-dir') }}/pdns.gsqlite3.conf
    - user: {{ powerdns.config.setuid }}
    - group: {{ powerdns.config.setuid }}
    - mode: 644
    - template: jinja
    - source: salt://powerdns/templates/pdns_sqlite.conf.jinja
    - makedirs: True

powerdns_schema_sqlite3:
  cmd.script:
    - source: salt://powerdns/files/sqlite_schema_load.sh
    - name: sqlite_schema_load.sh {{ powerdns.lookup.backend_sqlite3_file }}
    - runas: {{ powerdns.config.setuid }}
    - creates: {{ powerdns.lookup.backend_sqlite3_file }}
    - require:
      - pkg: {{ powerdns.lookup.backend_sqlite3_pkg }}


