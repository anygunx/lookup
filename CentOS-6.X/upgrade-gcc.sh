#!/bin/sh

VERSION=4.9.1

echo "Upgrade gcc ${VERSION}"

if [ ! -f "gcc-${VERSION}.tar.gz" ]; then

  wget ftp://10.10.10.252/pub/develop-kits/gcc-${VERSION}.tar.gz

fi

if [ ! -f "gcc-${VERSION}.tar.gz" ]; then

  wget http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.gz

fi



if [ ! -x "gcc-${VERSION}" ]; then
  tar -xvpf gcc-${VERSION}.tar.gz
fi


cd "gcc-${VERSION}"
./contrib/download_prerequisites
cd ..

if [ ! -x "gcc-build-${VERSION}" ]; then
  mkdir "gcc-build-${VERSION}"
fi

cd "gcc-build-${VERSION}"

../gcc-${VERSION}/configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-checking=release --enable-languages=c,c++ --disable-multilib

make -j8

make install

