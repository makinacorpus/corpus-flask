{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}
{{cfg.name}}-htaccess:
  file.managed:
    - name: {{data.htaccess}}
    - source: ''
    - user: www-data
    - group: www-data
    - mode: 770

{% if data.get('http_users', {}) %}
{% for userrow in data.http_users %}
{% for user, passwd in userrow.items() %}
{{cfg.name}}-{{user}}-htaccess:
  webutil.user_exists:
    - name: {{user}}
    - password: {{passwd}}
    - htpasswd_file: {{data.htaccess}}
    - options: m
    - force: true
    - watch:
      - file: {{cfg.name}}-htaccess
{% endfor %}
{% endfor %}
{% endif %}  

{{cfg.name}}-www-data:
  user.present:
    - name: www-data
    - optional_groups:
      - {{cfg.group}}
    - remove_groups: false

prepreqs-{{cfg.name}}:
  pkg.installed:
    - watch:
      - user: {{cfg.name}}-www-data
    - pkgs:
      - apache2-utils
      - autoconf
      - automake
      - build-essential
      - bzip2
      - cython
      - gettext
      - git
      - groff
      - libbz2-dev
      - libcairo2-dev
      - libcairomm-1.0-dev
      - libcurl4-openssl-dev
      - libdb-dev
      - libfreetype6-dev
      - libgdbm-dev
      - liblcms2-2
      - liblcms2-dev
      - libmysqlclient-dev
      - libopenjpeg2
      - libopenjpeg-dev
      - libpq-dev
      - libreadline-dev
      - libsigc++-2.0-dev
      - libsqlite0-dev
      - libsqlite3-dev
      - libssl-dev
      - libtiff5
      - libtiff5-dev
      - libtool
      - libwebp5
      - libwebp-dev
      - libxml2-dev
      - libxslt1-dev
      - m4
      - man-db
      - pkg-config
      - poppler-utils
      - python-dev
      - python-imaging
      - python-numpy
      - python-setuptools
      - sqlite3
      - tcl8.4
      - tcl8.4-dev
      - tcl8.5
      - tcl8.5-dev
      - tk8.5-dev
      - zlib1g-dev
      # geodjango
      - libspatialite-dev
      - libspatialite5
      - gdal-bin
      - libgdal1-dev
      - libgeos-dev

{{cfg.name}}-dirs:
  file.directory:
    - makedirs: true
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - watch:
      - pkg: prepreqs-{{cfg.name}}
      - user: {{cfg.name}}-www-data
    - names:
      - {{cfg.data_root}}/cache
      - {{data.DATA_FOLDER}}

{% for i in ['cache'] %}
{{cfg.name}}-l-dirs-{{i}}:
  file.symlink:
    - watch:
      - file: {{cfg.name}}-dirs
    - name: {{cfg.project_root}}/{{i}}
    - target: {{cfg.data_root}}/{{i}}
{%endfor %}
