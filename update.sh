#!/bin/sh
#
# Executed periodically by istlab:iweb to update the web page
#

export PATH=/usr/local/bin:$PATH

cd web

# Fetch updates and see if something was fetched
git fetch 2>fetch.out || exit 1

if ! [ -s fetch.out ]
then
	exit 0
fi

# Show us what has changed
cat fetch.out
if egrep '[0-9a-f]{7}\.\.[0-9a-f]{7}' fetch.out >/dev/null
then
	git log `awk '/->/ {print $1}' fetch.out`
fi

# There is work to integrate; rebuild
git merge origin

# Check for errors
AE=$(git log -n 1 --format=%ae)
AN=$(git log -n 1 --format=%ae)
rm -rf ../sandbox
mkdir ../sandbox
cp -r * ../sandbox
cd ../sandbox

if ! make >make.out 2>&1 ; then
  (
    cat <<EOF
From: ISTLab web continuous integration <iweb@istlab.dmst.aueb.gr>
Subject: Failed ISTLab web page change
To: "$AN" <$AE>
Cc: Diomidis Spinellis <dds@aueb.gr>
Reply-To: Diomidis Spinellis <dds@aueb.gr>

Dear $AN,

Sadly, a change you appear to have made to the ISTLab web site has
broken its build.  This is not a big problem; your changes will not be
integrated until the build succeeds.  The log of the build process appears
below. Typically errors occur due to invalid XML or BibTeX files. Please
correct the error and push again.

EOF
  cat make.out
  ) |
  /usr/sbin/sendmail dds@aueb.gr $AE
  rm -rf ../sandbox
  exit 1
fi
cd ../web
rm -rf ../sandbox

make clean html report brochure && \
rm -rf /home/dds/web/istlab/content/* && \
tar -C public_html -cf - . | tar -mU -C /home/dds/web/istlab/content -xf -
