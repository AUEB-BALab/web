title: PEVE (ΠΕΒΕ)
date:  20090301
category: projects
completed: 1
id: p_peve_sense_09
shortname: PEVE (ΠΕΒΕ)
projtitle: Funding Programme for Basic Research
startdate: 20090301
enddate: 20100901
web_site:  
our_budget: 9,400 €
total_budget: 640,000 €
funding_agency: Athens University of Economics and Business
funding_programme:  
project_code:  
logo: peve_logo.jpg  
scientific_coordinator: m_dds
contact: m_bkarak
project_manager: m_bkarak
type: rtd
international: no

<i>Integrating Domain-Specific Languages with General-Purpose Languages</i>
<br/><br/>
Domain-specific languages (DSL) are small, usually declarative languages that focus
on a specific problem domain. SQL and regular expressions are two of the most
common DSL's. General-purpose languages (GPL) such as C, C++ and Java are
covering a wider application domain, but lack expressive power when applicable to
specific problems. Usually DSL's are implemented as external application libraries
when used by GPLs and the compiler is unaware of the DSL syntax and data types,
creating a series of problems in the software development process.  
<br/><br/>
Our approach attempts to fill this scientific gap will introduce J% (j-mod), a DSL-aware
programming language. J% will be an extension of the Java programming language.
Its prototype implementation consists of a pre-processor, which translates the J%
source code to Java compatible code.
<br/><br/>
The J% approach tries to give a more pragmatic approach to DSL integration. All
research efforts so far, have one of the following weaknesses:
<ul>
	<li>They deal with the problem for one DSL and for one GPL.</li>
	<li>They propose complex solutions that act as a burden to mainstream programming languages, obliging programmers to remember difficult semantics.</li>
	<li>They offer a new programming language that deals with the problem efficiently, but usually require a complete rewrite of complex DSL systems.</li>
</ul>
In J% we will avoid the aforementioned weaknesses. In addition, we will address the
theoretical aspects of the problem, like possible type system extension etc.
<br/><br/>
Our prototype implementation will have as target the Java programming language. As
a research result, we will provide a solid implementation and a more generalised
methodology that could guide the application of our techniques to other programming
languages like C and C++.
