{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}


{% macro set_env() %}
    - env:
      - FLASK_MODEULE: "salt_config"
{% endmacro %}

{{cfg.name}}-config:
  file.managed:
    - name: {{cfg.project_root}}/src/salt_config.py
    - source: salt://makina-projects/{{cfg.name}}/files/config.py
    - template: jinja
    - user: {{cfg.user}}
    - data: |
            {{scfg}}
    - group: {{cfg.group}}
    - makedirs: true

dbinstall-{{cfg.name}}:
  cmd.run:
    - name: {{data.py}} -c "from app import build_sample_db;build_sample_db()"
    - unless: test $(sqlite3 {{data.DATABASE_FILE}} "select count(*) from user") -gt 0
    {{ set_env}}
    - cwd: {{cfg.project_root}}
    - user: {{cfg.user}}
    - watch:
      - file: {{cfg.name}}-config
