import os
ADMIN='admin'
PASSWORD='admin'
BASE_DIR = os.path.dirname(__file__)
SECRET_KEY = 'development key'
DATA_FOLDER = os.path.join(BASE_DIR,'data')
DATABASE_FILE = 'app.sqlite'
SQLALCHEMY_DATABASE_URI = 'sqlite:///' + DATABASE_FILE
SQLALCHEMY_RECORD_QUERIES = True
ERROR_MAIL_FROM = 'foo@a.com'
ERROR_MAIL_TO = 'foo@abcom'
