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

make clean html report brochure && \
tar -C public_html -cf - . | tar -mU -C /home/dds/web/istlab/content -xf -
