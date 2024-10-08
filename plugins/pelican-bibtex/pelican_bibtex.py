"""
Pelican BibTeX
==============

A Pelican plugin that populates the context with a list of formatted
citations, loaded from a BibTeX file at a configurable path.

The use case for now is to generate a ``Publications'' page for academic
websites.
"""
# Author: Vlad Niculae <vlad@vene.ro>
# Unlicense (see UNLICENSE for details)

import logging
logger = logging.getLogger(__name__)

from pelican import signals

__version__ = '0.2.1'


def add_publications(generator):
    """
    Populates context with a list of BibTeX publications.

    Configuration
    -------------
    generator.settings['PUBLICATIONS_SRC']:
        local path to the BibTeX file to read.

    Output
    ------
    generator.context['publications']:
        List of tuples (key, year, text, bibtex, pdf, slides, poster).
        See Readme.md for more details.
    """
    if 'PUBLICATIONS_SRC' not in generator.settings:
        return
    try:
        from StringIO import StringIO
    except ImportError:
        from io import StringIO
    try:
        from pybtex.database.input.bibtex import Parser
        from pybtex.database.output.bibtex import Writer
        from pybtex.database import BibliographyData, PybtexError
        from pybtex.backends import html
        from pybtex.style.formatting import plain
    except ImportError:
        logger.warn('`pelican_bibtex` failed to load dependency `pybtex`')
        return

    refs_file = generator.settings['PUBLICATIONS_SRC']
    try:
        bibdata_all = Parser().parse_file(refs_file)
    except PybtexError as e:
        logger.error('`pelican_bibtex` failed to parse file %s: %s' % (
            refs_file,
            str(e)))
        exit(1)
        return

    publications = []

    # format entries
    plain_style = plain.Style()
    html_backend = html.Backend()
    formatted_entries = plain_style.format_entries(bibdata_all.entries.values())

    for formatted_entry in formatted_entries:
        key = formatted_entry.key
        entry = bibdata_all.entries[key]
        year = entry.fields.get('year')
        if not year:
            logger.error(f'`pelican_bibtex` Missing year field for {key}')
        XEcategory = entry.fields.get('XEcategory')
        if not XEcategory:
            logger.error(f'`pelican_bibtex` Missing XEcategory field for {key}')
        XEmember = entry.fields.get('XEmember')
        if not XEmember:
            logger.error(f'`pelican_bibtex` Missing XEmember field for {key}')

        XEProject = entry.fields.get('XEProject')
        url = entry.fields.get('XEurl')

        #render the bibtex string for the entry
        bib_buf = StringIO()
        bibdata_this = BibliographyData(entries={key: entry})
        Writer().write_stream(bibdata_this, bib_buf)
        text = formatted_entry.text.render(html_backend)

        # publications.append((key,
        #                      year,
        #                      text,
        #                      url,
        #                      XEmember,
        #                      XEcategory,
        #                      XEProject
        #                      ))
        publications.append({'key'    : key,
                             'year'   : year,
                             'text'   : text,
                             'url'    : url,
                             'XEmember' : XEmember,
                             'XEcategory' : XEcategory,
                             'XEProject' : XEProject})

    generator.context['publications'] = publications


def register():
    signals.generator_init.connect(add_publications)
