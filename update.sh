#!/bin/sh

cd web

# Fetch updates and see if something was fetched
git fetch 2>fetch.out
if [ -z fetch.out ]
then
	exit 0
fi

# There is work to integrate; rebuild
git merge
gmake clean html report brochure && \
tar -C $(HTML) -cf - . | tar -mU -C /home/dds/web/istlab/content -xf -"
