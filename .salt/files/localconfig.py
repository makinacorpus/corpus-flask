 #!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import (print_function,
                        division,
                        absolute_import)

try:
    from config import *
except ImportError:
    pass
{%- set cfg = salt['mc_project.get_configuration'](cfg) %}
{%- set data = cfg.data %}

{%- macro render_setting(setting, value=None) %}
{%- set setting = setting.strip() %}
{% if salt['mc_utils.is_a_set'](value)
      or salt['mc_utils.is_a_list'](value)
      or salt['mc_utils.is_a_dict'](value) %}
try:
    {{setting}} = json.loads("""{{salt['mc_utils.json_dump'](value, pretty=True)}}""".strip())
except ValueError:
    try:
        {{setting}} = json.loads("""{{salt['mc_utils.json_dump'](value)}}""".strip())
    except ValueError:
        {{setting}} = json.loads("""{{salt['mc_utils.json_dump'](value)}}""".replace('\n', '\\n').strip())
{% elif (
    salt['mc_utils.is_a_bool'](value)
    or salt['mc_utils.is_a_number'](value)
)%}
{{-setting}} = {{value}}
{% elif salt['mc_utils.is_a_str'](value) %}
{{-setting}} = """{{value}}"""
{% else %}
{{-setting}} = {{value}}
{%- endif %}
{%- endmacro %}

import json
{% for setting, value in data.get('flask_settings', {}).items() -%}
{{render_setting(setting, value)}}
{%- endfor %}
{% for setting, value in data.get('extra_flask_settings', {}).items() -%}
{{render_setting(setting, value)}}
{%- endfor %}
{% for setting, value in data.get('extra_settings', {}).items() %}
{{setting}} = {{value}}
{% endfor %}
# vim:set et sts=4 ts=4 tw=80: 
