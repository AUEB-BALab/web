# BALab-Web

This is the repository for the [BALab](https://www.balab.aueb.gr) web site. This system is used to create and maintain the website. The system manages information regarding:

* group members and alumni,
* research projects,
* publications,
* software.

This is a responsive website (mobile, tablets and computers), using HTML, CSS & Boostrap 3.3.7.
The technologies that are used are Pelican, Markdown & BiBTeX.
Text is written in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet),
while publication data is kept in [BiBTeX](https://en.wikipedia.org/wiki/BibTeX)
format
Data are transformed into static HTML pages by [Pelican](https://blog.getpelican.com/).

## Quick HOWTO

### Step by step guide to changes
To contribute to the web site you need to follow these steps.

* [Log into GitHub](https://github.com/join).
* Navigate to the [BALab web site repository](https://github.com/AUEB-BALab/web)
* Click on the `Fork` button on the top right to create your personal copy
* Add or change the files you want.
  * You can easily create a file with the `Create new file` button.
  * You can edit a file you're viewing by pressing the `Edit this file`
   (pencil button) icon.
* Preview the change if it is Markdown text, to ensure it appears as you
  want it.
  (Ignore the formatting of the `key: value` entries.)
* Add a meaningful message in the `Commit changes` place.
* Select the `Create a new branch for this commit and start a pull request`
  option.
* Give a meaningful name to the branch you are creating.
* Press the `Propose file change` button.
* When you've finished all your related changes, press the `Create pull request`
  button.
* Navigate to the [BALab web site repository](https://github.com/AUEB-BALab/web) again.
* Click on the `New pull request` button on the left.
* In the new page (`Compare changes`), press the `compare accross forks` link.
* From the `head fork` drop-down menu, choose the `Head Repository` (yourusername/web)
  and, then, the branch where you made the changes in the forked repository.
* Press the `Create pull request` button.

### Making specific contributions
* All text is formatted using Markdown.
  See [this guide](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) for a quick introduction.
* Some pages have `Key: Value` lines at the beginning.
  Keep these in a separate line each.
* To add a new seminar, add a file under `content/seminars`,
  using [this template](https://raw.githubusercontent.com/AUEB-BALab/web/master/doc/templates/seminar-example.md).
* To add a new member, add a file under `content/members`,
  using [this template](https://raw.githubusercontent.com/AUEB-BALab/web/master/doc/templates/member-associate-example.md).
* To add a new publication edit the file in `content/pubs.bib`.
  * Use a templete associated with your publication's type from [this file](https://github.com/AUEB-BALab/web/blob/master/doc/templates/publication-schema.bib).
  * You also can use a BibTeX entry exported from a digital library.
  * In all cases, you need to add the  `XEmember` and `XEcategory` fields,
    and change the url field to XEurl field and the doi field to XEdoi.
  * Look at existing entries for examples.
  * Use only the following text in `XEcategory`:
    * 'Monographs and Edited Volumes'
    * 'Journal Articles'
    * 'Book Chapters'
    * 'Conference Publications'
    * 'Technical Reports'
    * 'White Papers'
    * 'Magazine Articles'
    * 'Working Papers'
* To add a new associate, add a file under `content/alumni`,
  using [this template](https://raw.githubusercontent.com/AUEB-BALab/web/master/doc/templates/member-associate-example.md).
* To add a new project, add a file under `content/projects`,
  using [this template](https://raw.githubusercontent.com/AUEB-BALab/web/master/doc/templates/project-example.md).
* To add new software, add a file under `content/software`,
  using [this template](https://raw.githubusercontent.com/AUEB-BALab/web/master/doc/templates/software-example.md).
* To add a new email recipient add the name in the file `content/mail-extra`.
* To update a static page (ex. PhD Student Achievements), go to `pages`, follow the existing structure and use class="img-responsive" for images.
* To modify an existing page, edit the corresponding file.
* To add a yearly report (e.g. _Yearly Report 2020_),
  create a file under `content/yearly_reports`.

## Technical details

The site is implemented using [Pelican](http://docs.getpelican.com/en/stable/).

### Project Structure
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

### Document Templates
* `doc/templates/member-associate-example.md` : Template for a group member or associate
* `doc/templates/project-example.md` : Template for a research project
* `doc/templates/publication-schema.bib` : Bibtex entries templates

### Web site installation and deployment
To install Pelican you need:

* `python`
* `pelican` : pip install pelican
* `markdown` : pip install Markdown
* `typogrify` : pip install typogrify
* `pybtex`:  pip install pybtex

### Creating the site
* Locally: `pelican content/`
* To update the web site on the server: `bin/update/`
