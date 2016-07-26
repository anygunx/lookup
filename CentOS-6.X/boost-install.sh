#!/bin/sh

VERSION=1_55_0

echo "Upgrade gcc ${VERSION}"

if [ ! -f "boost_${VERSION}.zip" ]; then

  wget ftp://10.10.10.252/pub/develop-kits/boost_${VERSION}.zip

fi


if [ ! -x "boost_${VERSION}" ]; then
  7za x boost_${VERSION}.zip
fi

cd boost_${VERSION}

ls
`pwd` ./bootstarp.sh --with-system --with-filesystem 

./b2 install
