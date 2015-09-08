{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

include:
  - makina-projects.{{cfg.name}}.include.configs

{% macro set_env() %}
    - env:
      - FLASK_MODULE: "app.localconfig"
{% endmacro %}

dbinstall-{{cfg.name}}:
  cmd.run:
    - name: {{data.py}} -c "from {{data.PROJECT}} import build_sample_db;build_sample_db()"
    - unless: test $(sqlite3 {{data.DATABASE_FILE}} "select count(*) from user") -gt 0
    {{ set_env()}}
    - cwd: {{cfg.project_root}}
    - user: {{cfg.user}}
    - watch:
      - mc_proxy: {{cfg.name}}-configs-post
