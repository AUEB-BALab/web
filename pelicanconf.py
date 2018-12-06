#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
from datetime import datetime

JINJA_ENVIRONMENT = {'extensions': ['jinja2.ext.loopcontrols']}

AUTHOR = 'Efstathia Chioteli, Ioannis Batas'
SITENAME = 'BALab'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Europe/Athens'

DEFAULT_LANG = 'English'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = None

# Social widget
SOCIAL = ()

# Plugins
PLUGIN_PATHS = ['plugins/']
PLUGINS = ['pelican-bibtex']
PUBLICATIONS_SRC = 'content/pubs.bib'

THEME = 'theme'

DIRECT_TEMPLATES = ('publications','index')

DEFAULT_PAGINATION = False

DISPLAY_CATEGORIES_ON_MENU = True
DISPLAY_PAGES_ON_MENU = True
MENUITEMS = (
    ('Publications', 'publications.html'),
)

# directories to be copied into output/static/
STATIC_PATHS = ['img', 'css', 'js','images/']
# very useful for debugging purposes
DELETE_OUTPUT_DIRECTORY = True
RELATIVE_URLS = True

# Current year for recent publiations
CURRYEAR = datetime.today().year
