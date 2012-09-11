ISTLab-Web
==========

This is the [ISTLab](http://istlab.dmst.aueb.gr/) website project repository. This system is used to create and maintain the website. The system manages information regarding

* research groups
* group members
* research projects
* publications

The technologies that are used are Git, XML, XSLT, make, grep, BiBTeX, and bib2html

Data are kept in XML form (groups, members, projects) and for the publications BiBTeX is used. Data are transformed into static HTML pages by XSLT scripts and data validation checks are performed by XML validator (DTD schemas).

Project Structure
-----------------
* **bin** : win32 version of binaries that are needed by the system _note : OS X and Linux users and should install them separetaly._
* **build** : Temporary files that are used to locally build the website
* **data** : XML and bibtex user data
  * _groups_ : Research group data (XML)
  * _members_ : Members' information (XML)
  * _projects_ : Project information (XML)
  * _publications_ : Bibliographic data (Bibtex)
  * _rel_pages_ : Rogue HTML pages, which are assigned to a research group
* **doc** : System's documentation (still work in progress)
* **lists** : 
* **public_html** : 
* **schema** : System's DTDs and transformation scripts
* **tools** : Scripts and tools used by the system to build reports
* _Makefile_ : The system's operation is orchestrated by this make file. Common commands include
  * _html_ : Build the website locally
  * _val_ : Validate local data and report problems
  * _clean_ : Delete temporary build files (usually run this before using the _html_ target)
  
Dependencies
------------
* *make* : GNU make
* *bibtex* : LaTeX's bibtex tool
* *perl* : Perl programming Language (used only on reporting)
* *xmlstarlet* : A command-line tool that exposes _libxml_ basic facilities

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

* **doc/templates/group-sample.xml** : XML Template for a research group
* **doc/templates/member-example.xml** : XML Template for a group member 
* **doc/templates/project-example.xml** : XML Template for a research project
* **doc/templates/rel_page-example.xml** : XML Template for a group HTML page
* **doc/templates/publication-schema.bib** : Bibtex entries templates

To create,

* _a new group_, copy the template file to the _data/groups/_ directory
* _a new member_, copy the template file to the _data/members/_ directory 
* _a new project_, copy the template file to the _data/projects/_ directory
* _a group HTML page_, copy the template file to the _data/rel_page/_ directory
* _a new publication_, update the appropriate bib file in _data/publications/_ directory (common files for all groups)

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



