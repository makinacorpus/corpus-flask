import os
import sys
from flask import Flask, url_for, redirect, render_template, request
from flask.ext.sqlalchemy import SQLAlchemy
from wtforms import form, fields, validators
from flask.ext import admin, login
from flask.ext.admin.contrib import sqla
from flask.ext.admin import helpers, expose
import logging
from logging.handlers import SMTPHandler
from logging import StreamHandler
from flask.ext.script import Manager
from flask.ext.script import Server
from flask.ext.script import Shell

CONFIG_MODULE = os.environ.get('FLASK_MODULE', 'app.config')
# Create Flask application
app = Flask(__name__)
app.config.from_object(CONFIG_MODULE)

# Create in-memory database
import sqlalchemy.exc
db = SQLAlchemy(app)

from . import auth
from .models import *
from logging import Formatter

ADMINS = app.config['ERROR_MAIL_TO'].split(',')

def _make_context():
    return globals()


manager_script = Manager(app)
manager_script.add_command("runserver", Server())
manager_script.add_command("shell", Shell(make_context=_make_context))

if not app.debug:
    mail_handler = SMTPHandler(
        '127.0.0.1',
        app.config['ERROR_MAIL_FROM'],
        ADMINS, '[flask MyApp ERROR]')
    mail_handler.setLevel(logging.ERROR)
    mail_handler.setFormatter(Formatter(
'''
Message type:       %(levelname)s
Location:           %(pathname)s:%(lineno)d
Module:             %(module)s
Function:           %(funcName)s
Time:               %(asctime)s

Message:

%(message)s
'''))

    err_handler = StreamHandler(sys.stderr)
    err_handler.setLevel(logging.ERROR)
    err_handler.setFormatter(Formatter(
        '%(asctime)s %(levelname)s: %(message)s '
        '[in %(pathname)s:%(lineno)d]'))
    app.logger.addHandler(mail_handler)
    app.logger.addHandler(err_handler)


def build_sample_db():
    """
    Populate a small db with some example entries.
    """
    try:
        db.drop_all()
    except sqlalchemy.exc.OperationalError, exc:
        if 'unable to open database file' in exc.message:
            pass
        else:
            raise
    db.create_all()
    admin_user = User(login=app.config['ADMIN'],
                      password=app.config['PASSWORD'])
    db.session.add(admin_user)

    db.session.commit()

from . import views
