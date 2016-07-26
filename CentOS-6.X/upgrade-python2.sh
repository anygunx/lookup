#!/bin/sh

VERSION=2.7.9

echo "Upgrade python ${VERSION}"

if [ ! -f "Python-${VERSION}.tgz" ]; then

  wget ftp://10.10.10.252/pub/develop-kits/Python-${VERSION}.tgz

fi

if [ ! -f "Python-${VERSION}.tgz" ]; then

  wget http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/Python-${VERSION}.tgz

fi



if [ ! -x "Python-${VERSION}" ]; then
  tar -xvpf Python-${VERSION}.tgz
fi


#cd "gcc-${VERSION}"
#./contrib/download_prerequisites
#cd ..

if [ ! -x "python-build-${VERSION}" ]; then
  mkdir "python-build-${VERSION}"
fi

cd "python-build-${VERSION}"

../Python-${VERSION}/configure  --prefix=/usr/local --with-threads --enable-shared --enable-universalsdk

make -j8

make install

