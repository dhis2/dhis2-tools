#!/bin/bash

cd ./pkg
find . -iname  *~ -exec rm '{}' ';'
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
chmod 644 DEBIAN/md5sums
cd ..

fakeroot dpkg -b ./pkg $1

