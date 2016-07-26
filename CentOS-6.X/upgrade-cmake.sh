#!/bin/sh

VERSION=3.6.0

echo "Upgrade cmake ${VERSION}"

if [ ! -f "cmake-${VERSION}.tar.gz" ]; then

  wget ftp://10.10.10.252/pub/develop-kits/cmake-${VERSION}.tar.gz

fi

if [ ! -f "cmake-${VERSION}.tar.gz" ]; then

  wget http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/cmake-${VERSION}.tar.gz

fi



if [ ! -x "cmake-${VERSION}" ]; then
  tar -xvpf cmake-${VERSION}.tar.gz
fi


#cd "gcc-${VERSION}"
#./contrib/download_prerequisites
#cd ..

if [ ! -x "cmake-build-${VERSION}" ]; then
  mkdir "cmake-build-${VERSION}"
fi

cd "cmake-build-${VERSION}"

../cmake-${VERSION}/configure 

make -j8

make install

