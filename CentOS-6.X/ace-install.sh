#!/bin/sh

VERSION=6.3.4
echo "Upgrade ACE ${VERSION}"

if [ ! -f "ACE-src-${VERSION}.tar.bz2" ]; then

  wget http://download.dre.vanderbilt.edu/previous_versions/ACE-src-${VERSION}.tar.bz2

fi


if [ ! -x "ACE-src-${VERSION}.tar.bz2" ]; then
  tar vxjpf ACE-src-${VERSION}.tar.bz2
fi

cd ACE_wrappers

export ACE_ROOT=`pwd`

./bin/mwc.pl -type make -static ./ace/ace.mwc

cd ace

echo '#define ACE_HAS_IPV6' > config.h
echo '#include "config-linux.h"' >> config.h 

make -j8

cd ..

ln -s `pwd`/ace /usr/local/include/ace
ln -s `pwd`/lib/libACE_Compression.a /usr/local/lib64/libACE_Compression.a
ln -s `pwd`/lib/libACE_ETCL.a /usr/local/lib64/libACE_ETCL.a
ln -s `pwd`/lib/libACE_ETCL_Parser.a /usr/local/lib64/libACE_ETCL_Parser.a
ln -s `pwd`/lib/libACE_Monitor_Control.a /usr/local/lib64/libACE_Monitor_Control.a
ln -s `pwd`/lib/libACE_RLECompression.a   /usr/local/lib64/libACE_RLECompression.a
ln -s `pwd`/lib/libACE.a /usr/local/lib64/libACE.a
