#perl -pi.bak -e 's,http://www.w3.org/TR/xhtml-modularization/DTD/,, if (/SYSTEM/)' *.mod *.dtd
perl -pi.bak -e 's,http://www.w3.org/TR/xhtml-modularization/DTD/,,' xhtml11.dtd
