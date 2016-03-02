ISTLab-Web
==========

This is the repository for the [ISTLab](http://istlab.dmst.aueb.gr/) web site. This system is used to create and maintain the website. The system manages information regarding

* research groups
* group members
* research projects
* publications

The technologies that are used are Git, XML, XSLT, make, grep, BiBTeX, and bib2xhtml

Data are kept in XML form (groups, members, projects) and for the publications BiBTeX is used. Data are transformed into static HTML pages by XSLT scripts and data validation checks are performed by XML validator (DTD schemas).

Quick HOWTO
-----------
* To add a new publication edit the file in `data/publications` corresponding to
the type of the publication you are adding.
You can use a BibTeX entry exported from a digital library.
However, you need to add the  `XEmember` and `XEgroup` fields;
look at existing entries for examples.
* To add a new member, add a file under `data/members`;
to add a new project, add a file under `data/projects`;
to modify an existing one, edit the corresponding file.
Again, when adding, you can get a head-start by copy-pasting a template
(see below).

Project Structure
-----------------
* `bin` : win32 version of binaries that are needed by the system _note : OS X and Linux users and should install them separetaly._
* `build` : Temporary files that are used to locally build the website
* `data` : XML and bibtex user data
  * `groups` : Research group data (XML)
  * `members` : Members' information (XML)
  * `projects` : Project information (XML)
  * `publications` : Bibliographic data (Bibtex)
  * `rel_pages` : Rogue HTML pages, which are assigned to a research group
* `doc` : System's documentation (still work in progress)
* `lists` : 
* `public_html` : 
* `schema` : System's DTDs and transformation scripts
* `tools` : Scripts and tools used by the system to build reports
* `Makefile` : The system's operation is orchestrated by this make file. Common commands include
  * `html` : Build the website locally
  * `val` : Validate local data and report problems
  * `clean` : Delete temporary build files (usually run this before using the `html` target)
  
Dependencies
------------
* *make* : GNU make
* *bibtex* : LaTeX's bibtex tool
* *perl* : Perl programming Language (used only on reporting)
* *xmlstarlet* : A command-line tool that exposes `libxml` basic facilities

**Note**: The win32 version of these utilities are included in the basic distribution ot the system.

ISTLab-web System Cheatsheet
----------------------------

### Checkout the Project repository ###

<code>git clone git@github.com:istlab/web.git</code>

### Adding a new file ###

<code>git add &lt;path/filename&gt;</code>

### Commit Local Changes ###

<code>git commit -m '&lt;your-comment-here&gt;' -a</code>

### Upload Changes to Main Repository ###

<code>git push</code>

### Building the Site Locally ###

<code>make clean html</code>

and then open <code>public_html/index.html</code> file with your favorite web browser.

### Document Templates ###

* `doc/templates/group-sample.xml` : XML Template for a research group
* `doc/templates/member-example.xml` : XML Template for a group member 
* `doc/templates/project-example.xml` : XML Template for a research project
* `doc/templates/rel_page-example.xml` : XML Template for a group HTML page
* `doc/templates/publication-schema.bib` : Bibtex entries templates

To create,

* _a new group_, copy the template file to the `data/groups/` directory
* _a new member_, copy the template file to the `data/members/` directory 
* _a new project_, copy the template file to the `data/projects/` directory
* _a group HTML page_, copy the template file to the `data/rel_page/` directory
* _a new publication_, update the appropriate bib file in `data/publications/` directory (common files for all groups)

### Validate Local Data ###

It is important to validate local data before commiting by using the <code>make val</code> command. For example:

<pre>
bkarak@pc:~/web [master]$ make val
Creating output directories
Creating unified database
---> Checking group data XML files ... 
---> Checking member data XML files ...
---> Checking project data XML files ...
---> Checking additional HTML pages ...
---> Checking announcements ...
---> Checking db.xml ...
</pre>



