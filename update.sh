#!/bin/sh

export PATH=/usr/local/bin:$PATH

cd web

# Fetch updates and see if something was fetched
git fetch 2>fetch.out
if ! [ -s fetch.out ]
then
	exit 0
fi

# There is work to integrate; rebuild
git merge origin

gmake clean html report brochure && \
tar -C public_html -cf - . | tar -mU -C /home/dds/web/istlab/content -xf -
