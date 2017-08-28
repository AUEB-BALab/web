BALab-Web
==========

This is the repository for the [BALab](http://istlab.dmst.aueb.gr/) web site. This system is used to create and maintain the website. The system manages information regarding

* group members and alumni
* research projects
* publications

This is a responsive website (mobile, tablets and computers); using HTML, CSS & Boostrap 3.3.7

The technologies that are used are Pelican, Markdown & BiBTeX

Data are kept in MARKDOWN form (members, alumni, projects) and for the publications BiBTeX is used. Data are transformed into static HTML pages by Pelican.

To install Pelican you need:
-----------
* `python`
* `pelican` : pip install pelican
* `markdown` : pip install Markdown
* `typogrify` : pip install typogrify
* `pybtex`:  pip install pybtex

## Creating the site
* Locally: `pelican content/`
* To update the web site on the server: `bin/update/`

Quick HOWTO
-----------
* To add a new publication edit the file in `content/pubs.bib`
You can use a BibTeX entry exported from a digital library.
However, you need to add the  `XEmember` and `XEcategory` fields and change url field to XEurl field and doi to XEdoi;
look at existing entries for examples. (`XEcategory` = 'Monographs and Edited Volumes','Journal Articles', 'Book Chapters', 'Conference Publications', 'Technical Reports','White Papers','Magazine Articles','Working Papers')
* To add a new member, add a file under `content/members`;
* To add a new associate, add a file under `content/alumni`;
* to add a new project, add a file under `content/projects`;
* To update a static page (ex. PhD Student Achievements), go to `pages`, follow the existing stracture and use class="img-responsive" for images;
* To modify an existing one, edit the corresponding file.

Again, when adding, you can get a head-start by copy-pasting a template
(see below).

Project Structure
-----------------
* `content` : MD and bibtex user data
  * `members` : Members' information (MD)
  * `alumni` : Alumni' information (MD)
  * `projects` : Project information (MD)
  * `pubs.bib` : publications - Bibliographic data (Bibtex)
  * `pages` : Rogue HTML pages, which are assigned to the site.
  * `images` : Put your image here
* `plugins` : bibtex plugin  
* `theme` : templates and static files
  * `templates` :
  * `static` :
	* `css` :
	* `images` :
	* `fonts` :
* `output` :

### Document Templates ###
* `doc/templates/member-associate-example.md` : Template for a group member or associate
* `doc/templates/project-example.md` : Template for a research project
* `doc/templates/publication-schema.bib` : Bibtex entries templates

To create,

* _a new member_, copy the template file to the `content/members/` directory
* _a new associate_, copy the template file to the `content/alumni/` directory
* _a new project_, copy the template file to the `content/projects/` directory
* _a new publication_, update the appropriate bib file in `content/pubs.bib` directory
