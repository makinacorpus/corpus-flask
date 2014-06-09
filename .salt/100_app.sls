{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

{{cfg.name}}-config:
  file.managed:
    - name: {{cfg.project_root}}/salt_config.py
    - source: salt://makina-projects/{{cfg.name}}/files/config.py
    - template: jinja
    - user: {{cfg.user}}
    - data: |
            {{scfg}}
    - group: {{cfg.group}}
    - makedirs: true

dbinstall-{{cfg.name}}:
  cmd.run:
    - name: {{cfg.project_root}}/bin/build_db
    - unless: test $(sqlite3 {{data.DATABASE_FILE}} "select count(*) from user") -gt 0
    - cwd: {{cfg.project_root}}
    - user: {{cfg.user}}
    - watch:
      - file: {{cfg.name}}-config
